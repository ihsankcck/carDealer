import DirectusService from "./service.js";

class LogoModel extends DirectusService {
  constructor() {
    super();
  }

  fetchLogo = async () => {
    const logo = await this.directus
      .items("logo")
      .readByQuery({ sort: ["id"] });
    return logo.data;
  };
}

const logoModel = new LogoModel();
export default logoModel;
