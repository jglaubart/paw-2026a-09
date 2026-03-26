(function () {
    var sliders = document.querySelectorAll("[data-hero-slider]");

    if (!sliders.length) {
        return;
    }

    function toArray(nodeList) {
        return Array.prototype.slice.call(nodeList || []);
    }

    function activateSlide(slider, nextIndex) {
        var slides = toArray(slider.querySelectorAll("[data-hero-slide]"));
        var dots = toArray(slider.querySelectorAll("[data-hero-slider-dot]"));

        slides.forEach(function (slide, index) {
            var isActive = index === nextIndex;

            if (isActive) {
                slide.classList.add("hero-slide-active");
            } else {
                slide.classList.remove("hero-slide-active");
            }

            slide.setAttribute("aria-hidden", isActive ? "false" : "true");
        });

        dots.forEach(function (dot, index) {
            if (index === nextIndex) {
                dot.classList.add("hero-slider-dot-active");
            } else {
                dot.classList.remove("hero-slider-dot-active");
            }
        });

        slider.setAttribute("data-hero-active-index", nextIndex);
    }

    function getActiveIndex(slider) {
        var currentIndex = parseInt(slider.getAttribute("data-hero-active-index"), 10);

        if (!isNaN(currentIndex)) {
            return currentIndex;
        }

        return 0;
    }

    function bindSlider(slider) {
        var slides = toArray(slider.querySelectorAll("[data-hero-slide]"));
        var dots = toArray(slider.querySelectorAll("[data-hero-slider-dot]"));
        var autoplayInterval = parseInt(slider.getAttribute("data-hero-slider-interval"), 10) || 6500;
        var timerId = null;
        var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

        if (slides.length < 2) {
            return;
        }

        function stopAutoplay() {
            if (timerId !== null) {
                window.clearInterval(timerId);
                timerId = null;
            }
        }

        function startAutoplay() {
            if (reduceMotion || document.hidden || timerId !== null) {
                return;
            }

            timerId = window.setInterval(function () {
                var nextIndex = (getActiveIndex(slider) + 1) % slides.length;
                activateSlide(slider, nextIndex);
            }, autoplayInterval);
        }

        dots.forEach(function (dot) {
            dot.addEventListener("click", function () {
                var nextIndex = parseInt(dot.getAttribute("data-hero-slide-index"), 10);

                if (isNaN(nextIndex)) {
                    return;
                }

                activateSlide(slider, nextIndex);
                stopAutoplay();
                startAutoplay();
            });
        });

        slider.addEventListener("mouseenter", stopAutoplay);
        slider.addEventListener("mouseleave", startAutoplay);
        slider.addEventListener("focusin", stopAutoplay);
        slider.addEventListener("focusout", startAutoplay);

        document.addEventListener("visibilitychange", function () {
            if (document.hidden) {
                stopAutoplay();
            } else {
                startAutoplay();
            }
        });

        activateSlide(slider, 0);
        startAutoplay();
    }

    toArray(sliders).forEach(bindSlider);
})();
