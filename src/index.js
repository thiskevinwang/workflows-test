var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import * as readline from "readline";
import * as process from "process";
import ora from "ora";
const sleep = (ms) => {
    return new Promise((resolve) => setTimeout(resolve, ms));
};
const rl = readline.createInterface({
    input: process.stdin,
    // stderr simply doesn't log anything in github actions
    output: process.stdout,
});
// print incrementing progress on a single line
const main = () => __awaiter(void 0, void 0, void 0, function* () {
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
        yield sleep(30);
    }
    const spinner = ora("Loading...");
    spinner.start();
    yield sleep(1000);
    spinner.succeed("Done");
    process.exit(0);
});
main();
