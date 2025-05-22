import { NextResponse } from 'next/server';
import * as Tesseract from 'tesseract.js';

export async function POST(req: Request) {
  try {
    const buffer = Buffer.from(await req.arrayBuffer());

    const {
      data: { text }
    } = await Tesseract.recognize(buffer, 'eng');

    return NextResponse.json({ text }, { status: 200 });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
