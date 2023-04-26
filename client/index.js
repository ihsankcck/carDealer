import express from "express";
import bodyParser from "body-parser";

import * as pageController from "./controllers/page-controller.js";
import * as formController from "./controllers/form-controller.js";
import settingsModel from "./model/settings-model.js";
import pageModel from "./model/page-model.js";

const app = express();
const port = 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.set("view engine", "pug");
app.use(express.static("public"));

app.use("/cms", (req, res) => {
  const fullUrl = "http://localhost:8055" + req.url;
  res.redirect(fullUrl);
});

app.use(async function (req, res, next) {
  const excludeMiddleware = ["login"];
  for (let i = 0; i < excludeMiddleware.length; i++) {
    if (excludeMiddleware[i] === req.path) {
      return next();
    }
  }

  try {
    const [settings, pages] = await Promise.all([
      settingsModel.fetchSetting(),
      pageModel.fetchPages(),
    ]);

    let about = pages.find((page) => page.slug.includes("hakkimizda"));

    if (about) {
      const shortSummaryText = String(about.summary).substring(0, 150) + "...";
      about = {
        ...about,
        shortSummaryText,
      };
    }

    // Fetch data
    res.locals.layoutData = {
      settings,
      pages,
      about,
      url: req.url,
    };
    return next();
  } catch (error) {
    return next(); // or throw new Error(err)
  }
});

app.get("/", pageController.homePage);
app.get("/arabalar", pageController.carsPage);
app.get("/:slug", pageController.detailPage);

app.post("/form", formController.sendMessage);

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
