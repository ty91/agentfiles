---
name: remote-mac
description: Taeyoung uses air (a mobile MacBook Air) and mini (a Mac mini server) over Tailscale. mini hosts personal agents and asynchronous development environments. Use when a task involves the other Mac, remote execution, persistent or scheduled work, or locating an existing agent or development session.
---

# Remote Mac

## Environment

- `air`: MacBook Air for interactive development and mobile use. SSH target: `ssh taeyoung@air`.
- `mini`: Mac mini server hosting personal agents and asynchronous development environments. SSH: `ssh taeyoung@mini`.
- Both SSH usernames are `taeyoung`, confirmed by the user. Use these short hostnames.
- SSH check on 2026-09-07 from `air`: `mini` authenticated as `taeyoung` and reported hostname `taeyoungui-Macmini.local`; `air` refused TCP port 22. Recheck when needed; do not assume SSH access to `air` is enabled.
- These are the only machines in scope for this skill; other tailnet peers are not work targets.
- Tailscale connects the machines. Do not assume the current session is on either particular Mac.

## When the other Mac matters

Work in the current checkout by default. The Mac mini's existence alone is not a reason to move a task there.

Consider the Mac mini when work must continue after the laptop disconnects, a task concerns a personal agent or scheduled job, or an existing development session needs to be resumed. Locate the relevant checkout, process, logs, or scheduler on its actual host before acting. Moving a conversation does not move its processes or scheduled jobs.

## Before remote work

- Confirm the current host and intended target when execution location affects the task.
- Use `tailscale status --json` to check the named target's current IP and online state. Use the SSH targets above; consult local SSH configuration for any connection options. Ask for missing details only when needed for the task. Do not treat an online peer as sufficient identification.
- Verify the remote host, user, and working directory before making changes. Keep long-running work on the target independent of the initiating SSH connection, using its existing execution setup.
- Distinguish existing personal-agent services from task-owned development processes. Clean up only the processes started for the task; changes to existing services must be within the user's requested scope.
- Diagnose Tailscale connectivity, SSH access, and application health separately. A network failure alone is not a reason to restart an agent service.
