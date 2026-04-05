(function () {
    var rails = document.querySelectorAll("[data-production-rail]");

    if (!rails.length) {
        return;
    }

    function toArray(nodeList) {
        return Array.prototype.slice.call(nodeList || []);
    }

    toArray(rails).forEach(function (rail) {
        var cards = rail.querySelector(".section-row-cards");
        var prevButton = rail.querySelector("[data-rail-prev]");
        var nextButton = rail.querySelector("[data-rail-next]");

        if (!cards || !prevButton || !nextButton) {
            return;
        }

        function stepSize() {
            return Math.max(cards.clientWidth * 0.72, 260);
        }

        function updateButtons() {
            var maxScrollLeft = cards.scrollWidth - cards.clientWidth;
            var hasOverflow = maxScrollLeft > 8;

            rail.classList.toggle("production-list-shell-scrollable", hasOverflow);
            prevButton.disabled = !hasOverflow || cards.scrollLeft <= 8;
            nextButton.disabled = !hasOverflow || cards.scrollLeft >= maxScrollLeft - 8;
        }

        prevButton.addEventListener("click", function () {
            cards.scrollBy({ left: -stepSize(), behavior: "smooth" });
        });

        nextButton.addEventListener("click", function () {
            cards.scrollBy({ left: stepSize(), behavior: "smooth" });
        });

        cards.addEventListener("scroll", updateButtons, { passive: true });
        window.addEventListener("resize", updateButtons);
        updateButtons();
    });
})();
