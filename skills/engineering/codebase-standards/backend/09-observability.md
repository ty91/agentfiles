# 09. Observability

In production the code is invisible; the logs are the only witness. A log is an API for the operator: structured, leveled with fixed meanings, and correlated to the request that caused it. Silence and noise are the same failure, because both leave the reader of an incident without an answer.

## 1. A log line is a record, not prose

Log structured fields with stable names, so logs can be queried like data. An interpolated sentence can only be found by someone who guesses its wording; a field can be filtered, counted, and alerted on. The logger is the only output channel: a leftover print statement is a log line with no level, no fields, and no place in anyone's query.

## 2. Levels are a contract

`error` means someone should act. `warn` means the system handled something it should not have had to. `info` marks a state change worth an audit trail. `debug` exists for development and is off in production. The calibration is the point: an error nobody acts on teaches operators to ignore errors, and after enough false alarms the real one arrives unread.

## 3. Every line joins a story

A correlation id, from the request or the job, flows into every layer that can log, so one incident reads as one thread instead of scattered fragments. This means services and jobs receive a logger as a dependency; a layer that cannot log is a layer whose failures surface nowhere, and it will be exactly the layer where the interesting failure happens.

## 4. Silence and noise are the same failure

Every swallowed error is a missing log line; 08-error-handling's "never swallow" is this document's twin rule, and both trigger on the same bare catch. But the fix is not logging everything: a line per loop iteration buries the one line that matters. Hold every log line to one test: during an incident, does this help the reader decide what to do next? Add the lines that do; delete the lines that do not.
