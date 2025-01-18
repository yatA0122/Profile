document.addEventListener('DOMContentLoaded', function () {

    const dropzone = document.getElementById('dropzone');

    const playlist = document.querySelector('.playlist');

    const playButton = document.querySelector('.btn-play');

    const stopButton = document.querySelector('.btn-stop');

    const progressBar = document.getElementById('progress-bar');

    const intervalInput = document.getElementById('interval-number');

   const intervalTime = document.getElementById('interval-time');

    const loopCount = document.getElementById('loopCount');

    const intervalCountDisplay = document.getElementById('intervalCount');

    let audioFiles = [];

    let currentAudioIndex = 0;

    let audio = new Audio();

    let intervalId;

    let loopCounter = 0;

    let countdownIntervalId;

 

    intervalTime.style.visibility = 'hidden'; // 初期状態で非表示

 

    dropzone.addEventListener('dragover', function (e) {

        e.preventDefault();

        dropzone.classList.add('dragover');

    });

 

    dropzone.addEventListener('dragleave', function () {

        dropzone.classList.remove('dragover');

    });

 

    dropzone.addEventListener('drop', function (e) {

        e.preventDefault();

        dropzone.classList.remove('dragover');

        const files = e.dataTransfer.files;

        for (let i = 0; i < files.length; i++) {

            if (files[i].type === 'audio/mpeg') {

                if (audioFiles.length < 5) {

                    audioFiles.push(files[i]);

                    const li = document.createElement('li');

                    li.textContent = `${audioFiles.length}  ${files[i].name}`;

                    playlist.appendChild(li);

                } else {

                    alert('5個までしか入りません。順番を入れ替えるなどの場合は画面を一度更新してください。');

                    break;

                }

            }

        }

    });

 

    playButton.addEventListener('click', function () {

        if (audioFiles.length > 0) {

            playAudio();

        }

    });

 

    stopButton.addEventListener('click', function () {

        stopAudio();

    });

 

    function playAudio() {

        if (currentAudioIndex < audioFiles.length) {

            intervalTime.style.visibility = 'hidden'; // 再生開始時に非表示

            const file = audioFiles[currentAudioIndex];

            audio.src = URL.createObjectURL(file);

            audio.play();

            audio.addEventListener('ended', onAudioEnded);

            updateProgressBar();

            updatePlaylist();

       }

    }

 

    function stopAudio() {

        audio.pause();

        audio.currentTime = 0;

        clearInterval(intervalId);

        clearInterval(countdownIntervalId);

        progressBar.value = 0;

        intervalTime.textContent = '';

        intervalTime.style.visibility = 'hidden'; // 停止ボタンを押したときに非表示

        loopCounter = 0;

        loopCount.textContent = loopCounter;

        intervalCountDisplay.textContent = '';

        currentAudioIndex = 0; // Reset to start from the beginning

        updatePlaylist(true);

    }

 

    function onAudioEnded() {

        currentAudioIndex++;

        if (currentAudioIndex >= audioFiles.length) {

            currentAudioIndex = 0;

            loopCounter++;

            loopCount.textContent = loopCounter;

        }

        const interval = parseInt(intervalInput.value, 10);

        startCountdown(interval);

        setTimeout(playAudio, interval * 1000);

    }

 

    function updateProgressBar() {

        intervalId = setInterval(function () {

            progressBar.value = (audio.currentTime / audio.duration) * 100;

        }, 1000);

    }

 

    function startCountdown(seconds) {

        clearInterval(countdownIntervalId);

        intervalCountDisplay.textContent = seconds;

        intervalTime.style.visibility = 'visible'; // カウントダウン開始時に表示

        countdownIntervalId = setInterval(function () {

            if (seconds > 0) {

                seconds--;

                intervalCountDisplay.textContent = seconds;

            } else {

                clearInterval(countdownIntervalId);

                intervalTime.style.visibility = 'hidden'; // カウントダウン終了時に非表示

            }

        }, 1000);

    }

 

    function updatePlaylist(reset = false) {

        const items = playlist.querySelectorAll('li');

        items.forEach((item, index) => {

            if (reset || index !== currentAudioIndex) {

                item.classList.remove('playing');

                console.log(`Removed playing class from item ${index}`);

            } else {

                item.classList.add('playing');

                console.log(`Added playing class to item ${index}`);

            }

        });

    }

});