import { Router } from "express";
import * as os from 'os';

const router = Router();

const getCoresController = router.get("/", (_, res) => {
  try {
        const cores = os.cpus().length;
        const coreLengthCheck = cores > 0 ? cores : "no";
        res.json({ "message": `${coreLengthCheck} core(s) are available on this machine.`})
  } catch (error) {
    console.log("An error has occurred: ", error);
  }
});

export default getCoresController;