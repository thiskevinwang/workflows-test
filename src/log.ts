import * as core from "@actions/core";
import pino from "pino";

const log_level = core.getInput("log_level") || "info";

function main() {
  const logger = pino({
    level: log_level,
    transport: {
      target: "pino-pretty",
      options: {
        colorize: true,
      },
    },
  });

  logger.trace("This is a trace message");
  logger.debug("This is a debug message");
  logger.info("This is an info message");
  logger.warn("This is a warning message");
  logger.error("This is an error message");
  logger.fatal("This is a fatal message");
}

main();
