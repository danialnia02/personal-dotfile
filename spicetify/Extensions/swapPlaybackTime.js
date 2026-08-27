// NAME: Swap Playback Time
// DESCRIPTION: Keep elapsed time on the left and total duration on the right of the playback bar.
// Measures the rendered positions and corrects them, so it works regardless of what Spotify's
// own styles do (row-reverse, order, rtl). Inline styles beat stylesheet rules and CSS layers.

(function swapPlaybackTime() {
	if (!document.body) {
		setTimeout(swapPlaybackTime, 100);
		return;
	}

	function fix() {
		document.querySelectorAll(".playback-bar").forEach(bar => {
			const elapsed = bar.querySelector(".playback-bar__progress-time-elapsed");
			const duration = bar.querySelector(".main-playbackBarRemainingTime-container");
			if (!elapsed || !duration) return;

			const a = elapsed.getBoundingClientRect();
			const b = duration.getBoundingClientRect();
			// Not laid out yet.
			if (a.width === 0 && b.width === 0) return;

			// Elapsed must sit to the left of duration.
			if (a.left > b.left) {
				bar.style.setProperty("flex-direction", "row-reverse", "important");
				// If it was already reversed, that flip is what broke it - go back to row.
				const a2 = elapsed.getBoundingClientRect();
				const b2 = duration.getBoundingClientRect();
				if (a2.left > b2.left) {
					bar.style.setProperty("flex-direction", "row", "important");
				}
			}
		});
	}

	new MutationObserver(fix).observe(document.body, { childList: true, subtree: true });
	fix();
})();
