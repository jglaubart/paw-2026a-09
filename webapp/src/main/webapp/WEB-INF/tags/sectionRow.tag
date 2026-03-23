<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless" %>
<%@ attribute name="title"    required="true" %>
<%@ attribute name="subtitle" required="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<section class="section-row">
    <div class="section-row-header">
        <div class="section-row-header-text">
            <h2 class="section-row-title"><c:out value="${title}" /></h2>
            <c:if test="${not empty subtitle}">
                <p class="section-row-subtitle"><c:out value="${subtitle}" /></p>
            </c:if>
        </div>
        <div class="section-row-nav" aria-label="Navegar sección">
            <paw:button text="←" cssClass="section-row-nav-btn" ariaLabel="Ver anteriores" />
            <paw:button text="→" cssClass="section-row-nav-btn" ariaLabel="Ver siguientes" />
        </div>
    </div>
    <div class="section-row-cards">
        <jsp:doBody />
    </div>
</section>
