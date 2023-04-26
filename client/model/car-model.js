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
}

const carModel = new CarModel();
export default carModel;
