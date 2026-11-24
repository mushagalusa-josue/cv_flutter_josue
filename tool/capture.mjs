import assert from 'node:assert/strict';
import { chromium } from 'playwright';
import { mkdir, rename } from 'node:fs/promises';

const output = 'docs/screenshots';
const base = process.env.CV_URL ?? 'http://127.0.0.1:8080/';
const email = `demonstration-${Date.now()}@example.com`;
const password = 'Demonstration2026';
await mkdir(output, { recursive: true });
const browser = await chromium.launch({ args: ['--no-sandbox'] });
try {
  const page = await browser.newPage({
    viewport: { width: 430, height: 932 },
    recordVideo: { dir: 'build/demo-recordings', size: { width: 430, height: 932 } },
  });
  const video = page.video();
  const button = (name) => page.getByRole('button', { name, exact: true });
  const enter = async (name, value) => {
    await page.getByRole('textbox', { name, exact: true }).click();
    await page.keyboard.press('ControlOrMeta+A');
    await page.keyboard.insertText(value);
  };
  const visible = (name) => page.getByText(name, { exact: true }).last().waitFor();
  const capture = (name) =>
    page.screenshot({ path: `${output}/${name}.png`, animations: 'disabled' });
  const pause = () => page.waitForTimeout(1200);
  const open = async () => {
    await page.goto(base);
    await page.locator('flt-semantics-placeholder').evaluate((element) => element.click());
    await button('Se connecter').waitFor();
  };
  const credentials = async (value) => {
    await enter('E-mail', email);
    await enter('Mot de passe', value);
  };

  await open();
  await capture('01-connexion');
  await credentials(password);
  await button('Créer un compte').click();
  await visible('Compte créé. Vous pouvez vous connecter.');
  await pause();
  await credentials('incorrect');
  const rejection = page.waitForResponse((response) =>
    response.url().endsWith('/accounts/login') && response.status() === 401);
  await button('Se connecter').click();
  await rejection;
  await visible('Email ou mot de passe incorrect');
  await pause();
  await credentials(password);
  await button('Se connecter').click();
  await page.getByRole('heading', { name: 'Accueil', exact: true }).waitFor();
  await capture('02-accueil');
  await page.getByRole('tab', { name: 'Famille', exact: true }).click();
  await button('Ajouter un membre').click();
  for (const [field, value] of Object.entries({
    Nom: 'Exemple',
    Postnom: 'Démo',
    Prénom: 'Camille',
    'Lieu de naissance': 'Bukavu',
    'Date de naissance (AAAA-MM-JJ)': '1995-06-15',
    'Lien de parenté': 'Cousine',
  })) {
    await enter(field, value);
  }
  await pause();
  await button('Enregistrer').click();
  const member = button('Camille Exemple Démo Cousine');
  await member.waitFor();
  await member.click();
  await button('Fermer').waitFor();
  assert.match(await page.locator('body').ariaSnapshot(), /Lieu de naissance · Bukavu/);
  await pause();
  await button('Fermer').click();
  await button('Modifier').click();
  await enter('Lieu de naissance', 'Goma');
  await button('Enregistrer').click();
  await button('Modifier').waitFor();

  await open();
  await credentials(password);
  await button('Se connecter').click();
  await page.getByRole('heading', { name: 'Accueil', exact: true }).waitFor();
  await page.getByRole('tab', { name: 'Famille', exact: true }).click();
  await member.click();
  await button('Fermer').waitFor();
  assert.match(await page.locator('body').ariaSnapshot(), /Lieu de naissance · Goma/);
  await pause();
  await button('Fermer').click();
  await button('Supprimer').click();
  await button('Annuler').waitFor();
  await button('Supprimer').last().click();
  await visible('Aucun membre enregistré.');
  await pause();

  await page.getByRole('tab', { name: 'Contact', exact: true }).click();
  await page.getByRole('heading', { name: 'Contact', exact: true }).waitFor();
  await capture('04-contact');
  await button('Se déconnecter').click();
  await button('Se connecter').waitFor();
  await pause();
  await page.close();
  await rename(await video.path(), 'docs/demonstration.webm');
} finally {
  await browser.close();
}
