import { chromium } from 'playwright';
import { mkdir } from 'node:fs/promises';

const output = 'docs/screenshots';
await mkdir(output, { recursive: true });
const browser = await chromium.launch({ args: ['--no-sandbox'] });
try {
  const page = await browser.newPage({ viewport: { width: 430, height: 932 } });
  await page.goto(process.env.CV_URL ?? 'http://127.0.0.1:8080/');
  // Ask Flutter Web to expose its semantics tree to the browser.
  await page.locator('flt-semantics-placeholder').evaluate((button) => button.click());
  const connect = page.getByRole('button', { name: 'Se connecter', exact: true });
  await connect.waitFor();
  const capture = async (name) =>
    page.screenshot({ path: `${output}/${name}.png`, animations: 'disabled' });

  await capture('01-connexion');

  await connect.click();
  await page.getByText('Compétences techniques', { exact: true }).waitFor();
  await capture('02-accueil');

  // Tap the navigation destinations. Their centers are equally spaced.
  await page.mouse.click(215, 886);
  await page.getByText('Ma famille', { exact: true }).waitFor();
  await page.waitForTimeout(350);
  await capture('03-famille');

  await page.mouse.click(358, 886);
  await page.getByText('Me contacter', { exact: true }).waitFor();
  await page.waitForTimeout(350);
  await capture('04-contact');
} finally {
  await browser.close();
}
