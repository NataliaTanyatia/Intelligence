import { NextResponse } from 'next/server';
import { chromium } from 'playwright';

export async function POST(req: Request) {
  const { url, action } = await req.json();

  if (!url || !action) {
    return NextResponse.json({ error: 'Missing url or action' }, { status: 400 });
  }

  try {
    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto(url);

    let result: any;
    let contentType: string = 'application/octet-stream';

    switch (action) {
      case 'blob':
      case 'screenshot':
        const buffer = await page.screenshot({ fullPage: true });
        result = buffer;
        contentType = 'image/png';
        break;
      case 'html':
        const html = await page.content();
        result = html;
        contentType = 'text/html';
        break;
      default:
        result = 'Page visited, no recognized action.';
        contentType = 'text/plain';
    }

    await browser.close();

    if (Buffer.isBuffer(result)) {
      return new NextResponse(result, {
        headers: {
          'Content-Type': contentType,
          'Content-Disposition': 'attachment; filename="blob_output"' 
        }
      });
    }

    return NextResponse.json({ result }, { status: 200 });

  } catch (err: any) {
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
