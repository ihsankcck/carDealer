import { Directus } from "@directus/sdk";

const directus = new Directus("http://localhost:8055/");

async function start() {
  // AUTHENTICATION

  let authenticated = false;

  // Try to authenticate with token if exists
  try {
    await directus.auth.refresh();
    authenticated = true;
  } catch (error) {}

  // Let's login in case we don't have token or it is invalid / expired
  while (!authenticated) {
    const email = "admin@example.com";
    const password = "Sifre123";

    try {
      await directus.auth.login({ email, password });
      authenticated = true;
    } catch (error) {
      console.log("Invalid credentials");
    }
  }
}

start();

class DirectusService {
  constructor() {
    this.directus = directus;
  }
}

export default DirectusService;
