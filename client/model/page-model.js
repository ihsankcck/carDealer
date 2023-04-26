import DirectusService from "./service.js";

class PageModel extends DirectusService {
  constructor() {
    super();
  }

  fetchPages = async () => {
    const pages = await this.directus
      .items("sayfalar")
      .readByQuery({ sort: ["id"] });
    return pages.data;
  };

  fetchPageBySlug = async (slug) => {
    const pageDetail = await this.directus.items("sayfalar").readByQuery({
      sort: ["id"],
      filter: {
        slug: {
          _eq: slug,
        },
      },
    });

    return pageDetail.data[0];
  };
}

const pageModel = new PageModel();
export default pageModel;
