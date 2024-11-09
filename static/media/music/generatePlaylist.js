const fs = require('fs');
const path = require('path');

const musicDir = path.join(__dirname);
const outputFilePath = path.join(__dirname, 'playlist.json');

fs.readdir(musicDir, (err, files) => {
  if (err) {
    console.error('Error reading music directory:', err);
    return;
  }

  const mp3Files = files.filter(file => path.extname(file).toLowerCase() === '.mp3');
  const playlist = mp3Files.map(file => ({ title: path.basename(file, '.mp3'), url: `/media/music/${file}` }));

  fs.writeFile(outputFilePath, JSON.stringify(playlist, null, 2), err => {
    if (err) {
      console.error('Error writing playlist file:', err);
    } else {
      console.log('Playlist generated successfully.');
    }
  });
});