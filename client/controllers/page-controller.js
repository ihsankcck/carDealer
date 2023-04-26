import carModel from "../model/car-model.js";
import mainpageModel from "../model/mainpage-model.js";
import pageModel from "../model/page-model.js";
import faqModel from "../model/faq-model.js";

const { fetchPageBySlug } = pageModel;
const { fetchCars } = carModel;
const { fetchMainpage } = mainpageModel;
const { fetchFaq } = faqModel;

export const homePage = async (req, res) => {
  const [cars, mainpage] = await Promise.all([fetchCars(), fetchMainpage()]);
  res.render("index", { title: "Ana Sayfa", cars, mainpage });
};

export const detailPage = async (req, res) => {
  const slug = req.params.slug;

  if (slug === "hakkimizda") {
    const [pageDetail, faqs] = await Promise.all([
      fetchPageBySlug(slug),
      fetchFaq(),
    ]);

    return res.render("about", {
      title: pageDetail?.baslik,
      pageDetail,
      faqs,
    });
  }

  const pageDetail = await fetchPageBySlug(slug);

  const templates = {
    iletisim: "contact",
  };

  return res.render(templates[slug] ?? "detail", {
    title: pageDetail?.baslik,
    pageDetail,
  });
};

export const carsPage = async (req, res) => {
  const [pageDetail, cars] = await Promise.all([
    fetchPageBySlug("arabalar"),
    fetchCars(),
  ]);

  res.render("cars", { title: "Arabalar", cars, pageDetail });
};
