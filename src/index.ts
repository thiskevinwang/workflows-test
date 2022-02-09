import * as readline from "readline";
import * as process from "process";

const sleep = (ms: number) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

const rl = readline.createInterface({
  input: process.stdin,
  // stderr simply doesn't log anything in github actions
  output: process.stdout,
});

// print incrementing progress on a single line
const main = async () => {
  rl.on("SIGINT", () => {
    if (process.listenerCount?.("SIGINT") === 0) {
      // @ts-ignore
      process.emit("SIGINT");
    } else {
      rl.close();
      process.kill(process.pid, "SIGINT");
    }
  });

  for (let i = 0; i < 101; i++) {
    rl.write(`${i}%`);
    readline.cursorTo(process.stdout, 0);
    await sleep(50);
  }
  return;
};

main();