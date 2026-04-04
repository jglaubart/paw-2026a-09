<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="name" required="false" %>
<%@ attribute name="currentValue" required="false" type="java.lang.Double" %>
<%@ attribute name="max" required="false" type="java.lang.Integer" %>
<%@ attribute name="groupLabel" required="false" %>
<%@ attribute name="promptText" required="false" %>
<%@ attribute name="autosubmit" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ratingName" value="${not empty name ? name : 'score'}" />
<c:set var="ratingMax" value="${max != null ? max : 5}" />
<c:set var="selectedValue" value="${currentValue != null ? currentValue : 0}" />
<c:set var="ratingGroupLabel" value="${not empty groupLabel ? groupLabel : 'Calificación'}" />
<c:set var="ratingPromptText" value="${not empty promptText ? promptText : 'Tocá una estrella para puntuar'}" />
<c:set var="autoSubmitEnabled" value="${autosubmit != null ? autosubmit : false}" />

<div class="star-rating"
     data-star-rating
     data-selected="${selectedValue}"
     data-max="${ratingMax}"
     data-prompt-text="${ratingPromptText}"
     data-success-text="Guardada"
     data-error-text="No se pudo guardar. Reintentá."
     data-autosubmit="${autoSubmitEnabled}">
    <c:if test="${not autoSubmitEnabled}">
        <input type="hidden"
               name="${ratingName}"
               value="${selectedValue > 0 ? selectedValue : ''}"
               data-star-rating-hidden-input />
    </c:if>
    <div class="star-rating-control" role="group" aria-label="${ratingGroupLabel}">
        <c:forEach var="i" begin="1" end="${ratingMax}">
            <button type="${autoSubmitEnabled ? 'submit' : 'button'}"
                    class="star-rating-star ${selectedValue >= i ? 'star-rating-star-active' : ''} ${selectedValue < i and selectedValue + 0.5 >= i ? 'star-rating-star-half' : ''}"
                    name="${ratingName}"
                    value="${i}"
                    data-star-rating-star
                    data-rating-value="${i}"
                    aria-label="Calificar con ${i} estrella${i == 1 ? '' : 's'}">
                <span aria-hidden="true">★</span>
            </button>
        </c:forEach>
    </div>

    <p class="star-rating-caption" data-star-rating-caption aria-live="polite">
        <c:choose>
            <c:when test="${selectedValue > 0}">
                <c:out value="${selectedValue}" />/<c:out value="${ratingMax}" />
            </c:when>
            <c:otherwise>
                <c:out value="${ratingPromptText}" />
            </c:otherwise>
        </c:choose>
    </p>
</div>
