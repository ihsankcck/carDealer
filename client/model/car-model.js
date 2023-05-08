import DirectusService from "./service.js";

class CarModel extends DirectusService {
  constructor() {
    super();
  }

  fetchCars = async () => {
    const cars = await this.directus
      .items("cars")
      .readByQuery({ sort: ["id"] });
    return cars.data;
  };

  fetchShowCaseCars = async () => {
    const cars = await this.directus.items("cars").readByQuery({
      sort: ["id"],
      filter: {
        is_showcase: {
          _eq: true,
        },
      },
    });
    return cars.data;
  };

  fetchCarDetailtBySlug = async (slug) => {
    const carDetail = await this.directus.items("cars").readByQuery({
      filter: {
        slug: {
          _eq: slug,
        },
      },
      fields: ["*", "images.directus_files_id"],
    });

    return carDetail;
  };
}

const carModel = new CarModel();
export default carModel;
