\use client'; >> "app/(authenticated)/ocr-tool/page.tsx"
echo  >> "app/(authenticated)/ocr-tool/page.tsx"
echo import { useState } from \react';

export default function OcrToolPage() {
  const [url, setUrl] = useState(\' );
  const [ocrText, setOcrText] = useState(\' );

  async function extractTextFromUrl() {
    // Fetch blob from Playwright
    const blobRes = await fetch('/api/playwright', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ url, action: 'blob' })
    });

    const blob = await blobRes.blob();

    // Send raw blob to OCR API
    const ocrRes = await fetch('/api/ocr', {
      method: 'POST',
      body: blob
    });

    const { text } = await ocrRes.json();
    setOcrText(text);
  }

  return (
    <div className="p-4 space-y-4">
      <h1 className="text-xl font-bold">OCR from Web Blob</h1>

      <input
        type="text"
        className="w-full border p-2 rounded"
        placeholder="Enter URL to extract text from"
        value={url}
        onChange={(e) => setUrl(e.target.value)}
      />

      <button
        className="mt-2 px-4 py-1 bg-purple-700 text-white rounded"
        onClick={extractTextFromUrl}
      >
        Extract Text
      </button>

      {ocrText && (
        <div className="mt-4 border p-2 bg-gray-100 rounded">
          <h2 className="font-semibold mb-1">OCR Result:</h2>
          <pre>{ocrText}</pre>
        </div>
      )}
    </div>
  );
}
