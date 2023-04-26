import DirectusService from "./service.js";

class SettingsModel extends DirectusService {
  constructor() {
    super();
  }

  fetchSetting = async () => {
    const settings = await this.directus.settings.read();
    return settings;
  };
}

const settingsModel = new SettingsModel();
export default settingsModel;
