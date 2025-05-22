\use client'; >> "app/(authenticated)/multimodal/page.tsx"
echo  >> "app/(authenticated)/multimodal/page.tsx"
echo import { useState } from \react';

export default function MultimodalPage() {
  const [fileType, setFileType] = useState('text');
  const [content, setContent] = useState(\' );
  const [url, setUrl] = useState(\' );
  const [blobUrl, setBlobUrl] = useState(\' );
  }

  return (
    <div className="p-4 space-y-4">
      <h1 className="text-xl font-bold">Multimodal File Generator</h1>

      <div>
        <label className="block font-semibold">Content:</label>
        <textarea
          className="w-full border p-2 rounded"
          rows={4}
          value={content}
          onChange={(e) => setContent(e.target.value)}
        />
        <select
          className="mt-2 border p-1"
          value={fileType}
          onChange={(e) => setFileType(e.target.value)}
        >
          <option value="text">Text</option>
        </select>
        <button className="ml-2 px-4 py-1 bg-blue-600 text-white rounded" onClick={generateFile}>
          Generate File
        </button>
      </div>

      <div>
        <label className="block font-semibold">URL for Blob:</label>
        <input
          className="w-full border p-2 rounded"
          type="text"
          value={url}
          onChange={(e) => setUrl(e.target.value)}
        />
        <button className="mt-2 px-4 py-1 bg-green-600 text-white rounded" onClick={getBlobFromWeb}>
          Get Blob
        </button>
      </div>

      {blobUrl && (
        <div>
          <h2 className="font-semibold">Blob Result:</h2>
          <img src={blobUrl} alt="Blob from web" className="border rounded max-w-full" />
        </div>
      )}
    </div>
  );
}
