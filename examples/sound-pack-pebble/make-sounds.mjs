// Regenerates the Pebble pack's .wav files from plain maths: no samples, no
// third-party audio. Run from this folder with `node make-sounds.mjs`.
// Output: 22.05 kHz, mono, 16-bit WAV, each well under 100 KB.
import { writeFileSync } from 'node:fs';

const RATE = 22050;

// One soft, woody "pebble" note: a sine with a quiet octave, a fast attack and an
// exponential decay. `glide` bends the pitch slightly at the start.
function note(freq, seconds, { decay = 9, glide = 0 } = {}) {
  const n = Math.round(RATE * seconds);
  const out = new Float32Array(n);
  let phase = 0;
  for (let i = 0; i < n; i++) {
    const t = i / RATE;
    const f = freq * (1 + glide * Math.exp(-t * 60));
    phase += (2 * Math.PI * f) / RATE;
    const env = Math.min(1, t / 0.004) * Math.exp(-t * decay);
    out[i] = env * (0.8 * Math.sin(phase) + 0.2 * Math.sin(2 * phase));
  }
  return out;
}

// Lay notes out on a timeline: [startSeconds, samples].
function mix(seconds, parts) {
  const out = new Float32Array(Math.round(RATE * seconds));
  for (const [at, samples] of parts) {
    const start = Math.round(at * RATE);
    for (let i = 0; i < samples.length && start + i < out.length; i++) out[start + i] += samples[i];
  }
  return out;
}

function writeWav(file, samples, peak = 0.7) {
  const max = Math.max(...samples.map(Math.abs)) || 1;
  const data = Buffer.alloc(samples.length * 2);
  samples.forEach((s, i) => data.writeInt16LE(Math.round((s / max) * peak * 32767), i * 2));
  const header = Buffer.alloc(44);
  header.write('RIFF', 0);
  header.writeUInt32LE(36 + data.length, 4);
  header.write('WAVE', 8);
  header.write('fmt ', 12);
  header.writeUInt32LE(16, 16); // PCM chunk size
  header.writeUInt16LE(1, 20); // PCM
  header.writeUInt16LE(1, 22); // mono
  header.writeUInt32LE(RATE, 24);
  header.writeUInt32LE(RATE * 2, 28); // byte rate
  header.writeUInt16LE(2, 32); // block align
  header.writeUInt16LE(16, 34); // bits per sample
  header.write('data', 36);
  header.writeUInt32LE(data.length, 40);
  writeFileSync(file, Buffer.concat([header, data]));
}

const C5 = 523.25, E5 = 659.25, G5 = 783.99, A5 = 880, C6 = 1046.5;
const dir = new URL('./pebble/', import.meta.url);

// Rising pair = arrived, falling pair = left.
writeWav(new URL('join.wav', dir), mix(0.45, [[0, note(C5, 0.3)], [0.11, note(G5, 0.34)]]));
writeWav(new URL('leave.wav', dir), mix(0.45, [[0, note(G5, 0.3)], [0.11, note(C5, 0.34)]]));
// Teammates: the same shape, smaller and higher, so it reads as "someone else".
writeWav(new URL('peer-join.wav', dir), mix(0.3, [[0, note(E5, 0.18, { decay: 14 })], [0.07, note(A5, 0.22, { decay: 14 })]]));
writeWav(new URL('peer-leave.wav', dir), mix(0.3, [[0, note(A5, 0.18, { decay: 14 })], [0.07, note(E5, 0.22, { decay: 14 })]]));
// Incoming call: a three-note figure, twice. The one sound meant to get attention.
const ring = (at) => [[at, note(C5, 0.2)], [at + 0.1, note(E5, 0.2)], [at + 0.2, note(G5, 0.3)]];
writeWav(new URL('ring.wav', dir), mix(1.05, [...ring(0), ...ring(0.5)]));
// Message: one short knock with a small downward bend, like a pebble on wood.
writeWav(new URL('message.wav', dir), mix(0.2, [[0, note(C6, 0.18, { decay: 22, glide: 0.06 })]]));
