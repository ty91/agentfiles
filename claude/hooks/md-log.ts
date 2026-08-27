#!/usr/bin/env bun
import {
	appendFileSync,
	closeSync,
	existsSync,
	fstatSync,
	mkdirSync,
	openSync,
	readFileSync,
	readSync,
	writeFileSync,
} from "node:fs";
import { homedir } from "node:os";
import { dirname, isAbsolute, join, resolve } from "node:path";

const STATE_DIR = join(homedir(), ".local", "state", "md-log");

type LogState = {
	enabled: boolean;
	path?: string;
	cursor: number;
};

type ContentBlock = { type: string; text?: string };

type TranscriptEntry = {
	type?: string;
	isSidechain?: boolean;
	isMeta?: boolean;
	message?: { role?: string; content?: string | ContentBlock[] };
};

const SKIP_PREFIXES = [
	"<local-command-stdout",
	"<local-command-stderr",
	"<bash-input",
	"<bash-stdout",
	"<bash-stderr",
	"<system-reminder",
	"<task-notification",
	"[Request interrupted",
	"Caveat: The messages below",
];

function statePath(sessionId: string): string {
	return join(STATE_DIR, `${sessionId}.json`);
}

function readState(sessionId: string): LogState | undefined {
	try {
		const parsed = JSON.parse(readFileSync(statePath(sessionId), "utf8")) as Partial<LogState>;
		if (typeof parsed.enabled !== "boolean") return undefined;
		return {
			enabled: parsed.enabled,
			path: typeof parsed.path === "string" ? parsed.path : undefined,
			cursor: Number.isInteger(parsed.cursor) ? (parsed.cursor as number) : -1,
		};
	} catch {
		return undefined;
	}
}

function writeState(sessionId: string, state: LogState): void {
	mkdirSync(STATE_DIR, { recursive: true });
	writeFileSync(statePath(sessionId), `${JSON.stringify(state, null, 2)}\n`, "utf8");
}

function unwrapQuotes(value: string): string {
	const first = value[0];
	const last = value[value.length - 1];
	if ((first === '"' && last === '"') || (first === "'" && last === "'")) {
		return value.slice(1, -1);
	}
	return value;
}

function resolveLogPath(rawPath: string, cwd: string): string {
	const unquoted = unwrapQuotes(rawPath.trim());
	const expanded = unquoted === "~"
		? homedir()
		: unquoted.startsWith("~/")
			? resolve(homedir(), unquoted.slice(2))
			: unquoted;
	return isAbsolute(expanded) ? resolve(expanded) : resolve(cwd, expanded);
}

function nonEmptyText(value: string): string | undefined {
	const text = value.trimEnd();
	return text.trim() ? text : undefined;
}

function extractText(content: string | ContentBlock[] | undefined): string | undefined {
	if (typeof content === "string") return nonEmptyText(content);
	if (!Array.isArray(content)) return undefined;
	return nonEmptyText(
		content
			.filter((block): block is { type: "text"; text: string } =>
				block.type === "text" && typeof block.text === "string",
			)
			.map((block) => block.text)
			.join("\n"),
	);
}

function compactCommandInvocation(text: string): string | undefined {
	const name = /<command-name>([^<\r\n]+)<\/command-name>/.exec(text)?.[1]?.trim();
	if (!name) return text;
	const args = /<command-args>([\s\S]*?)<\/command-args>/.exec(text)?.[1]?.trim();
	const marker = `> [!note] [skill] ${name.replace(/^\//, "")}`;
	return args ? `${marker}\n\n${args}` : marker;
}

function loggableUserText(text: string): string | undefined {
	if (SKIP_PREFIXES.some((prefix) => text.startsWith(prefix))) return undefined;
	if (text.includes("<command-name>")) return compactCommandInvocation(text);
	return text;
}

function formatSection(role: "user" | "assistant", text: string): string {
	const marker = role === "user" ? "> [!quote] You" : "> [!info] Claude";
	return `${marker}\n\n${text}`;
}

function separatorFor(path: string): string {
	const fd = openSync(path, "a+");
	try {
		const { size } = fstatSync(fd);
		if (size === 0) return "";
		const length = Math.min(size, 2);
		const buffer = Buffer.alloc(length);
		readSync(fd, buffer, 0, length, size - length);
		const ending = buffer.toString("utf8");
		if (ending.endsWith("\n\n")) return "";
		if (ending.endsWith("\n")) return "\n";
		return "\n\n";
	} finally {
		closeSync(fd);
	}
}

function appendMarkdown(path: string, markdown: string): void {
	mkdirSync(dirname(path), { recursive: true });
	const separator = separatorFor(path);
	appendFileSync(path, `${separator}${markdown.trimEnd()}\n`, "utf8");
}

function requireSessionId(): string {
	const sessionId = process.env.CLAUDE_CODE_SESSION_ID;
	if (!sessionId) {
		console.error("CLAUDE_CODE_SESSION_ID is not set");
		process.exit(1);
	}
	return sessionId;
}

function runOn(rawPath: string): void {
	const sessionId = requireSessionId();
	if (!rawPath.trim()) {
		console.error("Usage: md-log.ts on <md-path>");
		process.exit(1);
	}
	const path = resolveLogPath(rawPath, process.cwd());
	mkdirSync(dirname(path), { recursive: true });
	closeSync(openSync(path, "a"));
	writeState(sessionId, { enabled: true, path, cursor: -1 });
	console.log(`Logging conversation to ${path} (starting from the next user message)`);
}

function runOff(): void {
	const sessionId = requireSessionId();
	const state = readState(sessionId);
	if (!state?.enabled) {
		console.log("md-log is not active for this session");
		return;
	}
	writeState(sessionId, { ...state, enabled: false });
	console.log("Markdown conversation logging stopped");
}

async function runStop(): Promise<void> {
	const input = JSON.parse(await Bun.stdin.text()) as {
		session_id?: string;
		transcript_path?: string;
	};
	const sessionId = input.session_id;
	const transcriptPath = input.transcript_path;
	if (!sessionId || !transcriptPath || !existsSync(transcriptPath)) return;

	const state = readState(sessionId);
	if (!state?.enabled || !state.path) return;

	const lines = readFileSync(transcriptPath, "utf8")
		.split("\n")
		.filter((line) => line.trim());
	if (state.cursor < 0 || state.cursor > lines.length) {
		writeState(sessionId, { ...state, cursor: lines.length });
		return;
	}

	const sections: string[] = [];
	for (const line of lines.slice(state.cursor)) {
		let entry: TranscriptEntry;
		try {
			entry = JSON.parse(line) as TranscriptEntry;
		} catch {
			continue;
		}
		if (entry.isSidechain || entry.isMeta) continue;
		if (entry.type !== "user" && entry.type !== "assistant") continue;
		if (entry.message?.role !== entry.type) continue;

		const text = extractText(entry.message.content);
		if (!text) continue;

		if (entry.type === "user") {
			const loggable = loggableUserText(text);
			if (loggable) sections.push(formatSection("user", loggable));
		} else {
			sections.push(formatSection("assistant", text));
		}
	}

	for (const section of sections) {
		appendMarkdown(state.path, section);
	}
	writeState(sessionId, { ...state, cursor: lines.length });
}

const mode = process.argv[2];
try {
	if (mode === "on") {
		runOn(process.argv.slice(3).join(" "));
	} else if (mode === "off") {
		runOff();
	} else if (mode === "stop") {
		await runStop();
	} else {
		console.error("Usage: md-log.ts <on <md-path> | off | stop>");
		process.exit(1);
	}
} catch (error) {
	console.error(`md-log failed: ${error instanceof Error ? error.message : String(error)}`);
	process.exit(mode === "stop" ? 0 : 1);
}
