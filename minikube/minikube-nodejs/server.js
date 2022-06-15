import express, { json, urlencoded } from "express";

// Controllers
import homeController from "./controllers/homeController.js";
import getCoresController from "./controllers/getCoresController.js";

const app = express();
const port = process.env.PORT || 3000;

app.use(json());
app.use(
  urlencoded({
    extended: true,
  })
);

app.use(homeController);
app.use("/api/cores", getCoresController);

app.listen(port, () => console.log(`Server listening on: ${port}`));