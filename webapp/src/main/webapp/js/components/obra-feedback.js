(function () {
    var forms = document.querySelectorAll("[data-obra-feedback-form]");

    if (!forms.length || typeof window.fetch !== "function") {
        return;
    }

    function toArray(nodeList) {
        return Array.prototype.slice.call(nodeList || []);
    }

    function matches(element, selector) {
        var matcher = element.matches || element.msMatchesSelector || element.webkitMatchesSelector;
        return matcher ? matcher.call(element, selector) : false;
    }

    function closest(element, selector) {
        var current = element;

        while (current && current.nodeType === 1) {
            if (matches(current, selector)) {
                return current;
            }
            current = current.parentElement;
        }

        return null;
    }

    function parseNumber(value) {
        var parsed = parseFloat(value);
        return isNaN(parsed) ? null : parsed;
    }

    function parseInteger(value) {
        var parsed = parseInt(value, 10);
        return isNaN(parsed) ? null : parsed;
    }

    function formatScore(value) {
        var rounded;

        if (value === null || value === undefined) {
            return "--";
        }

        rounded = Math.round(value * 10) / 10;
        if (Math.floor(rounded) === rounded) {
            return String(rounded.toFixed(0));
        }

        return rounded.toFixed(1);
    }

    function reviewCountLabel(count) {
        return count + " resena" + (count === 1 ? "" : "s");
    }

    function feedbackMessage(errorCode) {
        if (errorCode === "missing_score") {
            return "Elegi una calificacion antes de guardar tu participacion.";
        }
        if (errorCode === "invalid_email") {
            return "Completa un mail valido antes de guardar.";
        }
        if (errorCode === "invalid_score") {
            return "Elegi un puntaje valido antes de guardar.";
        }
        if (errorCode === "invalid_production") {
            return "Selecciona una funcion valida para calificar.";
        }
        return "No se pudo guardar tu participacion. Reintenta.";
    }

    function showInlineMessage(form, type, message) {
        var messageNode = form.parentElement ? form.parentElement.querySelector("[data-feedback-inline-message]") : null;

        if (!messageNode) {
            return;
        }

        messageNode.textContent = message;
        messageNode.classList.remove("obra-action-feedback-wrap-hidden");
        messageNode.classList.remove("obra-inline-feedback-success");
        messageNode.classList.remove("obra-inline-feedback-warning");
        messageNode.classList.add(type === "success" ? "obra-inline-feedback-success" : "obra-inline-feedback-warning");
    }

    function findReviewCardByEmail(section, email) {
        var cards = toArray(section.querySelectorAll("[data-review-card]"));
        var index;

        for (index = 0; index < cards.length; index += 1) {
            if ((cards[index].getAttribute("data-review-email") || "") === email) {
                return cards[index];
            }
        }

        return null;
    }

    function ensureReviewsGrid(section, anchorNode) {
        var grid = section.querySelector("[data-feedback-reviews-grid]");

        if (grid) {
            return grid;
        }

        grid = document.createElement("div");
        grid.className = "obra-reviews-grid";
        grid.setAttribute("data-feedback-reviews-grid", "");

        if (anchorNode && anchorNode.parentElement === section) {
            section.insertBefore(grid, anchorNode);
        } else {
            section.appendChild(grid);
        }

        return grid;
    }

    function ensureEmptyState(section, anchorNode) {
        var emptyState = section.querySelector("[data-feedback-reviews-empty]");

        if (emptyState) {
            return emptyState;
        }

        emptyState = document.createElement("div");
        emptyState.className = "obra-reviews-empty";
        emptyState.setAttribute("data-feedback-reviews-empty", "");
        emptyState.textContent = "Todavia no hay resenas publicadas para esta obra.";

        if (anchorNode && anchorNode.parentElement === section) {
            section.insertBefore(emptyState, anchorNode);
        } else {
            section.appendChild(emptyState);
        }

        return emptyState;
    }

    function createReviewCard(email, body, score) {
        var card = document.createElement("div");
        var header = document.createElement("div");
        var avatar = document.createElement("span");
        var author = document.createElement("span");
        var scoreNode = document.createElement("span");
        var bodyNode = document.createElement("p");

        card.className = "obra-review-card";
        card.setAttribute("data-review-card", "");
        card.setAttribute("data-review-email", email);

        header.className = "obra-review-header";

        avatar.className = "obra-review-avatar";
        avatar.textContent = email ? email.charAt(0).toUpperCase() : "?";

        author.className = "obra-review-author";
        author.textContent = email;

        scoreNode.className = "obra-review-score";
        scoreNode.textContent = formatScore(score) + "/10";

        bodyNode.className = "obra-review-body";
        bodyNode.textContent = '"' + body + '"';

        header.appendChild(avatar);
        header.appendChild(author);
        header.appendChild(scoreNode);
        card.appendChild(header);
        card.appendChild(bodyNode);

        return card;
    }

    function updateReviewCard(section, email, body, score, reviewCount) {
        var interactPanel = section.querySelector(".obra-interact-panel");
        var existingCard = findReviewCardByEmail(section, email);
        var grid = section.querySelector("[data-feedback-reviews-grid]");
        var emptyState = section.querySelector("[data-feedback-reviews-empty]");
        var scoreNode;
        var bodyNode;

        if (body) {
            if (!grid) {
                grid = ensureReviewsGrid(section, interactPanel);
            }

            if (existingCard) {
                scoreNode = existingCard.querySelector(".obra-review-score");
                bodyNode = existingCard.querySelector(".obra-review-body");

                if (scoreNode) {
                    scoreNode.textContent = formatScore(score) + "/10";
                }
                if (bodyNode) {
                    bodyNode.textContent = '"' + body + '"';
                }
            } else {
                existingCard = createReviewCard(email, body, score);
                if (grid.firstChild) {
                    grid.insertBefore(existingCard, grid.firstChild);
                } else {
                    grid.appendChild(existingCard);
                }
            }

            if (emptyState) {
                emptyState.remove();
            }
        } else if (existingCard) {
            existingCard.remove();
            if (grid && !grid.children.length) {
                grid.remove();
                grid = null;
            }
        }

        if (reviewCount === 0) {
            if (grid) {
                grid.remove();
            }
            ensureEmptyState(section, interactPanel);
        } else {
            emptyState = section.querySelector("[data-feedback-reviews-empty]");
            if (emptyState) {
                emptyState.remove();
            }
        }
    }

    function ensureAverageBlock(section) {
        var avgBlock = section.querySelector("[data-feedback-avg-block]");
        var reviewsHead;
        var starsWrap;
        var starsBase;
        var starsFill;
        var avgValue;
        var reviewCount;

        if (avgBlock) {
            return avgBlock;
        }

        reviewsHead = section.querySelector(".obra-reviews-head");
        if (!reviewsHead) {
            return null;
        }

        avgBlock = document.createElement("span");
        avgBlock.className = "obra-avg-rating";
        avgBlock.setAttribute("data-feedback-avg-block", "");

        starsWrap = document.createElement("span");
        starsWrap.className = "obra-avg-stars";
        starsWrap.setAttribute("aria-hidden", "true");

        starsBase = document.createElement("span");
        starsBase.className = "obra-avg-stars-base";
        starsBase.textContent = "★★★★★★★★★★";

        starsFill = document.createElement("span");
        starsFill.className = "obra-avg-stars-fill";
        starsFill.setAttribute("data-feedback-avg-stars-fill", "");
        starsFill.textContent = "★★★★★★★★★★";

        starsWrap.appendChild(starsBase);
        starsWrap.appendChild(starsFill);

        avgValue = document.createElement("span");
        avgValue.className = "obra-avg-rating-value";
        avgValue.setAttribute("data-feedback-avg-value", "");
        avgValue.textContent = "-- / 10";

        reviewCount = document.createElement("span");
        reviewCount.className = "obra-avg-rating-meta";
        reviewCount.setAttribute("data-feedback-review-count", "");
        reviewCount.textContent = "0 resenas";

        avgBlock.appendChild(starsWrap);
        avgBlock.appendChild(avgValue);
        avgBlock.appendChild(reviewCount);
        reviewsHead.appendChild(avgBlock);

        return avgBlock;
    }

    function updateAverageSummary(section, response) {
        var avgRating = parseNumber(response.headers.get("X-Avg-Rating"));
        var reviewCount = parseInteger(response.headers.get("X-Review-Count"));
        var avgBlock = ensureAverageBlock(section);
        var avgValue;
        var starsFill;
        var reviewCountNode;

        if (!avgBlock) {
            return;
        }

        avgValue = avgBlock.querySelector("[data-feedback-avg-value]");
        starsFill = avgBlock.querySelector("[data-feedback-avg-stars-fill]");
        reviewCountNode = avgBlock.querySelector("[data-feedback-review-count]");

        if (avgRating === null) {
            avgBlock.hidden = true;
            return;
        }

        avgBlock.hidden = false;
        if (avgValue) {
            avgValue.textContent = formatScore(avgRating) + " / 10";
        }
        if (starsFill) {
            starsFill.style.width = Math.max(0, Math.min(100, avgRating * 10)) + "%";
        }
        if (reviewCountNode && reviewCount !== null) {
            reviewCountNode.textContent = reviewCountLabel(reviewCount);
        }
    }

    function updateUserScore(section, response) {
        var score = parseNumber(response.headers.get("X-User-Score"));
        var userScoreNode = section.querySelector("[data-feedback-user-score]");

        if (!userScoreNode || score === null) {
            return;
        }

        userScoreNode.textContent = formatScore(score) + "/10";
    }

    function setBusyState(form, busy) {
        var submitButton = form.querySelector("[data-feedback-submit]");

        form.setAttribute("data-feedback-busy", busy ? "true" : "false");
        if (submitButton) {
            submitButton.disabled = busy;
        }
    }

    function bindForm(form) {
        form.addEventListener("submit", function (event) {
            var section;
            var requestBody;
            var emailInput;
            var bodyInput;

            event.preventDefault();

            if (form.getAttribute("data-feedback-busy") === "true") {
                return;
            }

            if (typeof form.reportValidity === "function" && !form.reportValidity()) {
                return;
            }

            section = closest(form, ".obra-section");
            requestBody = new URLSearchParams(new FormData(form));
            emailInput = form.querySelector("input[name='email']");
            bodyInput = form.querySelector("textarea[name='body']");

            setBusyState(form, true);

            window.fetch(form.action, {
                method: form.method || "POST",
                credentials: "same-origin",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: requestBody.toString()
            }).then(function (response) {
                if (response.status === 204) {
                    var submitButton = form.querySelector("[data-feedback-submit]");
                    var reviewCount = parseInteger(response.headers.get("X-Review-Count"));
                    var userScore = parseNumber(response.headers.get("X-User-Score"));
                    var normalizedEmail = emailInput ? emailInput.value.trim().toLowerCase() : "";
                    var normalizedBody = bodyInput ? bodyInput.value.trim() : "";

                    showInlineMessage(form, "success", "Puntuacion y resena guardadas.");
                    if (section) {
                        updateAverageSummary(section, response);
                        updateUserScore(section, response);
                        if (reviewCount !== null && userScore !== null && normalizedEmail) {
                            updateReviewCard(section, normalizedEmail, normalizedBody, userScore, reviewCount);
                        }
                    }
                    if (submitButton) {
                        submitButton.textContent = "Actualizar participacion";
                    }
                    return null;
                }

                return response.text().then(function (errorCode) {
                    throw new Error((errorCode || "").trim() || "invalid_feedback");
                });
            }).catch(function (error) {
                showInlineMessage(form, "warning", feedbackMessage(error.message));
            }).then(function () {
                setBusyState(form, false);
            });
        });
    }

    toArray(forms).forEach(bindForm);
})();
