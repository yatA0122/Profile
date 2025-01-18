document.addEventListener('DOMContentLoaded', () => {
    const playButton = document.querySelector('.btn-play');
    const stopButton = document.querySelector('.btn-stop');
    const progressBar = document.getElementById('progress-bar');
    const loopCountDisplay = document.getElementById('loopCount');
    const intervalNumber = document.getElementById('interval-number');
    const intervalCount = document.getElementById('intervalCount');
    const intervalDisplay = document.getElementById('interval-time');
    const audioPlayer = new Audio();
    audioPlayer.loop = false;

    let loopCount = 0;
    let intervalCountdown = 0;
    let setIntervalID;
    let playList = [];
    let currentIndex = 0;

    // プレイリストを作成する関数
    function createPlaylist() {
        const trainLine = document.querySelector('input[name="line-selection"]:checked')?.id;
        const suspendValue = document.getElementById("suspend_pull-down").value;
        const delayValue = document.getElementById("delay_pull-down").value;
        const transfer = document.querySelector('input[name="transfer"]:checked')?.id;

        playList = []; // 新しいプレイリストを作成

        // 事由が選択されていない場合の処理
        if (!suspendValue && !delayValue) {
            alert("事由が選択されていません。");
            return; // 処理を中止
        }

        // 日本語の音声ファイルをプレイリストに追加
        if (trainLine) {
            switch (trainLine) {
                case 'yamanote':
                    playList.push("./voice/trainLine/yamanote_ja.mp3");
                    break;
                case 'keihin':
                    playList.push("./voice/trainLine/keihin_ja.mp3");
                    break;
                case 'yamanote_keihin':
                    playList.push("./voice/trainLine/yamanote_keihin_ja.mp3");
                    break;
            }
        }

        // 事由の音声ファイルを追加
        if (!delayValue) {
            playList.push(`./voice/suspend/ja/${suspendValue}.mp3`);
        }
        else if (!suspendValue) {
            playList.push(`./voice/delay/ja/${delayValue}.mp3`);
        }
        else{
            alert("「見合わせ」・「遅れ」どちらも事由が選択されています。");
            playList = [];
            return;
        }

        // transferの値を確認して追加
        if (transfer === 'transfer_true') {
            playList.push("./voice/transfer/transfer_ja.mp3");
        }

        // 英語の音声ファイルをプレイリストに追加
        if (trainLine) {
            switch (trainLine) {
                case 'yamanote':
                    playList.push("./voice/trainLine/yamanote_en.mp3");
                    break;
                case 'keihin':
                    playList.push("./voice/trainLine/keihin_en.mp3");
                    break;
                case 'yamanote_keihin':
                    playList.push("./voice/trainLine/yamanote_keihin_en.mp3");
                    break;
            }
        }

        // 英語の事由の音声ファイルを追加
        if (!delayValue && suspendValue) {
            playList.push(`./voice/suspend/en/${suspendValue}.mp3`);
        }
        else if (!suspendValue || delayValue) {
            playList.push(`./voice/delay/en/${delayValue}.mp3`);
        }
        else{
            alert("「見合わせ」・「遅れ」どちらも事由が選択されています。");
            playList = [];
            return;
        }

        if (transfer === 'transfer_true') {
            playList.push("./voice/transfer/transfer_en.mp3");
        }
        console.log(playList);
        // プレイリストが空でないことを確認
        if (playList.length === 0) {
            alert("再生する音声がありません。");
            return; // 処理を中止
        }
    }

    // 音声が終了した際の処理
    function handleAudioEnded() {
        currentIndex++; // インデックスを進める
        if (currentIndex < playList.length) {
            audioPlayer.src = playList[currentIndex]; // 次の音声ファイルを設定
            audioPlayer.play();
        } else {
            // プレイリストの最後まで再生した場合の処理
            currentIndex = 0; // インデックスをリセット
            loopCount++; // ループカウントを増やす
            loopCountDisplay.textContent = loopCount; // ループカウントを表示
            startInterval(); // インターバルの開始
        }
    }

    // インターバルを開始する関数
    function startInterval() {
        if (intervalNumber.value > 0) {
            clearInterval(setIntervalID); // 前回のインターバルをクリア
            intervalCountdown = 0; // カウントダウンのリセット
            intervalCount.textContent = intervalNumber.value; // 初期値をセット
            intervalDisplay.style.visibility = "visible"; // インターバルの表示を可視化

            setIntervalID = setInterval(() => {
                intervalCountdown++;
                intervalCount.textContent = intervalNumber.value - intervalCountdown;

                if (intervalCountdown >= intervalNumber.value) { // インターバル終了時
                    clearInterval(setIntervalID);
                    intervalDisplay.style.visibility = "hidden"; // 表示を隠す
                    intervalCountdown = 0; // カウントダウンのリセット
                    // インターバル後に再生を続ける
                    audioPlayer.src = playList[currentIndex]; // 現在のインデックスの音声ファイルを設定
                    audioPlayer.play();
                }
            }, 1000);
        }
    }

    // 再生ボタン用の関数
    function playAudio() {
        createPlaylist(); // プレイリストを作成
        if (playList.length === 0) return; // プレイリストが空なら再生しない
        currentIndex = 0; // インデックスをリセット
        audioPlayer.src = playList[currentIndex]; // 最初の音声ファイルを設定
        audioPlayer.play().catch(error => {
            if (error.name === 'AbortError') {
                console.log('再生が中断されました。');
            } else {
                console.error('再生エラー:', error);
            }
        });
        audioPlayer.addEventListener('ended', handleAudioEnded);
    }

    // 停止ボタン用の関数
    function stopAudio() {
        if (!audioPlayer.paused) {
            audioPlayer.pause();
            audioPlayer.currentTime = 0;
            updateProgress(); // 停止時にプログレスバーをリセット
        }
        clearInterval(setIntervalID); // インターバルをクリア
        progressBar.value = 0; // プログレスバーをリセット
        intervalCountdown = 0;
        intervalDisplay.style.visibility = "hidden"; // 表示を隠す
        currentIndex = 0; // インデックスをリセット
        playList = []; // プレイリストをクリア
    }

    // 音声再生中にプログレスバーを更新
    audioPlayer.addEventListener('timeupdate', () => {
        updateProgress();
    });

    // シークバーを動かした時に音声の再生位置を変更
    progressBar.addEventListener('input', () => {
        const duration = audioPlayer.duration;
        if (duration) {
            audioPlayer.currentTime = progressBar.value / 100 * duration;
        }
    });

    // プログレスバーを更新する関数
    function updateProgress() {
        if (audioPlayer.duration) {
            progressBar.value = (audioPlayer.currentTime / audioPlayer.duration) * 100;
        } else {
            progressBar.value = 0;
        }
    }

    playButton.onclick = playAudio;
    stopButton.onclick = stopAudio;
});
