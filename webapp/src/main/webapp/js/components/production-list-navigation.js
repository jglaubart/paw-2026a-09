(function () {
    var rails = document.querySelectorAll("[data-production-rail='true'], [data-production-rail]:not([data-production-rail='false'])");

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
            var hasLeft = hasOverflow && cards.scrollLeft > 8;
            var hasRight = hasOverflow && cards.scrollLeft < maxScrollLeft - 8;

            rail.classList.toggle("horizontal-rail-scrollable", hasOverflow);
            rail.classList.toggle("horizontal-rail-has-left", hasLeft);
            rail.classList.toggle("horizontal-rail-has-right", hasRight);
            prevButton.disabled = !hasLeft;
            nextButton.disabled = !hasRight;
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
