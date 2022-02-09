"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const readline = __importStar(require("readline"));
const process = __importStar(require("process"));
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
        yield sleep(50);
    }
    process.exit(0);
});
main();
