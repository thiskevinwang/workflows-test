import * as readline from "readline";
import * as process from "process";

const sleep = (ms: number) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

// print incrementing progress on a single line
const main = async () => {
  for (let i = 0; i < 101; i++) {
    readline.cursorTo(process.stdout, 0, 0);
    process.stdout.write(`Progress: ${i}%`);
    await sleep(50);
  }
  return;
};

main();
