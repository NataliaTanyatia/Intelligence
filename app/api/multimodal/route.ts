import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

export async function POST(req: Request) {
  const { fileType, content } = await req.json();

  if (!fileType || !content) {
    return NextResponse.json({ error: 'Missing fileType or content' }, { status: 400 });
  }

  const timestamp = Date.now();
  const fileName = `file_${timestamp}.${fileType}`;
  const outputDir = path.resolve(process.cwd(), 'generated_files');

  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  const filePath = path.join(outputDir, fileName);

  try {
    switch (fileType) {
      case 'text':
        fs.writeFileSync(filePath, content);
        break;
      default:
        return NextResponse.json({ error: `Unsupported file type: ${fileType}` }, { status: 400 });
    }

    return NextResponse.json({ success: true, filePath }, { status: 200 });
  } catch (err: any) {
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
