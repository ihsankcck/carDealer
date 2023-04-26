import DirectusService from "./service.js";

class FormModel extends DirectusService {
  constructor() {
    super();
  }

  saveRecord = async (payload) => {
    const response = await this.directus.items("forms").createOne(payload);
    return response;
  };
}

const formModel = new FormModel();
export default formModel;
