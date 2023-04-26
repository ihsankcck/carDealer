import DirectusService from "./service.js";

class MainpageModel extends DirectusService {
  constructor() {
    super();
  }

  fetchMainpage = async () => {
    const mainpage = await this.directus
      .items("mainPage")
      .readByQuery({ sort: ["id"] });
    return mainpage.data;
  };
}

const mainpageModel = new MainpageModel();
export default mainpageModel;
