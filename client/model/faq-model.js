import DirectusService from "./service.js";

class FaqModel extends DirectusService {
  constructor() {
    super();
  }

  fetchFaq = async () => {
    const faq = await this.directus.items("faq").readByQuery({ sort: ["id"] });
    return faq.data;
  };
}

const faqModel = new FaqModel();
export default faqModel;
