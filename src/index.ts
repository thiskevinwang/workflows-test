import * as readline from "readline";
import * as process from "process";
import ora from "ora";

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
  // rl.on("SIGINT", () => {
  //   if (process.listenerCount?.("SIGINT") === 0) {
  //     // @ts-ignore
  //     process.emit("SIGINT");
  //   } else {
  //     rl.close();
  //     process.kill(process.pid, "SIGINT");
  //   }
  // });

  for (let i = 0; i < 101; i++) {
    // rl.write(`${i}%`);
    readline.cursorTo(process.stdout, 0);
    readline.clearLine(process.stdout, 0);
    process.stdout.write(`${i}%`);
    await sleep(30);
  }

  // It appears that the spinner is hidden in github actions
  // This is good, but _how_ is this achieved?
  // https://github.com/thiskevinwang/workflows-test/runs/5120955325?check_suite_focus=true
  const spinner = ora("Loading...");
  spinner.start();
  await sleep(1000);
  spinner.succeed("Done");

  process.exit(0);
};

main();
