import React, { useState } from 'react';
import { Copy, Check, Download, FileCode, Folder, Terminal, Sparkles } from 'lucide-react';
import { FLUTTER_FILES, FlutterFile } from '../flutterCodeStore';

export const FlutterCodeViewer: React.FC = () => {
  const [selectedFile, setSelectedFile] = useState<FlutterFile>(FLUTTER_FILES[1]); // lib/main.dart default
  const [copied, setCopied] = useState(false);

  const copyToClipboard = () => {
    navigator.clipboard.writeText(selectedFile.code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const downloadFile = (file: FlutterFile) => {
    const blob = new Blob([file.code], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = file.filename;
    link.click();
    URL.revokeObjectURL(url);
  };

  const downloadAllAsBundle = () => {
    // Generate combined bundle script or alert
    const combined = FLUTTER_FILES.map(
      (f) => `// ==========================================\n// FILE: ${f.path}\n// ==========================================\n${f.code}\n\n`
    ).join('\n');

    const blob = new Blob([combined], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'zalono_partner_flutter_source_bundle.txt';
    link.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div className="bg-zinc-900 border border-zinc-800 rounded-3xl p-6 h-full flex flex-col shadow-2xl overflow-hidden">
      {/* Top Banner */}
      <div className="flex flex-wrap items-center justify-between gap-4 pb-4 border-b border-zinc-800">
        <div>
          <div className="flex items-center space-x-2">
            <span className="w-3 h-3 rounded-full bg-blue-500"></span>
            <h2 className="text-lg font-black text-white tracking-tight">
              Flutter & Dart Production Codebase
            </h2>
            <span className="bg-blue-500/10 border border-blue-500/30 text-blue-400 text-[10px] font-bold px-2 py-0.5 rounded-full">
              iOS & Android
            </span>
          </div>
          <p className="text-xs text-zinc-400 mt-1">
            Ready-to-run Dart files structured for Flutter 3.x with Cupertino icons, Google fonts & Material 3
          </p>
        </div>

        <div className="flex items-center space-x-2.5">
          <button
            onClick={copyToClipboard}
            className="flex items-center space-x-1.5 bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-xs font-bold px-3.5 py-2 rounded-xl transition active:scale-95 border border-zinc-700"
          >
            {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
            <span>{copied ? 'Copied' : 'Copy File'}</span>
          </button>

          <button
            onClick={downloadAllAsBundle}
            className="flex items-center space-x-1.5 bg-[#C52243] hover:bg-[#B31D3B] text-white text-xs font-bold px-4 py-2 rounded-xl transition active:scale-95 shadow-md shadow-rose-950/40"
          >
            <Download className="w-3.5 h-3.5" />
            <span>Download All Code</span>
          </button>
        </div>
      </div>

      {/* Terminal Command Tip */}
      <div className="bg-zinc-950 border border-zinc-800/80 rounded-2xl p-3 my-4 flex items-center justify-between text-xs">
        <div className="flex items-center space-x-2 text-zinc-300 font-mono">
          <Terminal className="w-4 h-4 text-emerald-400" />
          <span className="text-zinc-500">$</span>
          <span className="text-zinc-200">flutter create zalono_partner &amp;&amp; flutter run</span>
        </div>
        <span className="text-[11px] text-zinc-500 font-sans">
          Runs on both iOS Simulator &amp; Android Emulator
        </span>
      </div>

      {/* Main Grid: File Tree + Code Editor */}
      <div className="flex-1 grid grid-cols-1 lg:grid-cols-12 gap-4 min-h-0">
        {/* Left: File Tree Explorer */}
        <div className="lg:col-span-4 bg-zinc-950/70 border border-zinc-800 rounded-2xl p-3 overflow-y-auto no-scrollbar flex flex-col">
          <span className="text-[10px] font-black uppercase tracking-wider text-zinc-500 px-2 py-1 block">
            PROJECT EXPLORER (FLUTTER)
          </span>

          <div className="mt-2 space-y-1">
            {FLUTTER_FILES.map((file) => {
              const isSelected = selectedFile.path === file.path;
              return (
                <button
                  key={file.path}
                  onClick={() => setSelectedFile(file)}
                  className={`w-full text-left px-3 py-2 rounded-xl transition flex items-center justify-between text-xs ${
                    isSelected
                      ? 'bg-blue-600/20 text-blue-300 border border-blue-500/40 font-bold'
                      : 'hover:bg-zinc-800/60 text-zinc-400'
                  }`}
                >
                  <div className="flex items-center space-x-2 truncate">
                    <FileCode className={`w-3.5 h-3.5 shrink-0 ${isSelected ? 'text-blue-400' : 'text-zinc-500'}`} />
                    <span className="truncate">{file.path}</span>
                  </div>
                  <span className="text-[10px] font-mono uppercase text-zinc-500 ml-1 shrink-0">
                    {file.language}
                  </span>
                </button>
              );
            })}
          </div>

          <div className="mt-auto pt-4 border-t border-zinc-800/80 text-[11px] text-zinc-400 px-2">
            <p className="font-semibold text-zinc-300">File details:</p>
            <p className="text-[11px] text-zinc-500 mt-0.5 leading-snug">{selectedFile.description}</p>
          </div>
        </div>

        {/* Right: Code Content Display */}
        <div className="lg:col-span-8 bg-zinc-950 border border-zinc-800 rounded-2xl overflow-hidden flex flex-col">
          {/* Header */}
          <div className="bg-zinc-900/80 px-4 py-2.5 border-b border-zinc-800 flex items-center justify-between text-xs">
            <div className="flex items-center space-x-2">
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-500"></span>
              <span className="font-mono text-zinc-200 font-bold">{selectedFile.path}</span>
            </div>
            <button
              onClick={() => downloadFile(selectedFile)}
              className="text-[11px] text-zinc-400 hover:text-white flex items-center space-x-1"
            >
              <Download className="w-3 h-3" />
              <span>Save file</span>
            </button>
          </div>

          {/* Syntax Box */}
          <pre className="flex-1 p-4 overflow-auto font-mono text-xs text-zinc-200 leading-relaxed no-scrollbar select-text">
            <code>{selectedFile.code}</code>
          </pre>
        </div>
      </div>
    </div>
  );
};
