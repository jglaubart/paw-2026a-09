<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="variant" required="true" %>
<%@ attribute name="error" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:url var="searchUrl" value="/search" />
<c:set var="hasActiveFilters" value="${not empty param.genre or not empty param.theater or not empty param.dateFrom or not empty param.dateTo or param.available == 'true'}" />
<c:set var="activeFilterCount" value="${(not empty param.genre ? 1 : 0) + (not empty param.theater ? 1 : 0) + (not empty param.dateFrom ? 1 : 0) + (not empty param.dateTo ? 1 : 0) + (param.available == 'true' ? 1 : 0)}" />
<c:set var="searchFeedback" value="${not empty error ? error : dateRangeError}" />

<form action="${searchUrl}" method="get" class="search-form search-form-${variant} ${hasActiveFilters ? 'search-form-has-active-filters' : ''}" data-navbar-search>
    <c:choose>
        <c:when test="${variant == 'navbar'}">
            <div class="search-form-bar">
                <div class="search-form-shell">
                    <div class="search-form-details ${hasActiveFilters ? 'search-form-details-active' : ''}" data-search-popover>
                        <button type="button"
                                class="search-form-filter-toggle"
                                data-search-trigger
                                aria-controls="navbar-search-panel"
                                aria-expanded="false">
                            <span class="search-form-filter-icon" aria-hidden="true">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="1.9"
                                     stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="4" y1="6" x2="20" y2="6" />
                                    <line x1="7" y1="12" x2="17" y2="12" />
                                    <line x1="10" y1="18" x2="14" y2="18" />
                                </svg>
                            </span>
                            <span class="search-form-filter-label">Filtros</span>
                            <span class="search-form-filter-count ${activeFilterCount == 0 ? 'is-empty' : ''}" data-search-filter-count>
                                <c:out value="${activeFilterCount}" />
                            </span>
                        </button>

                        <div class="search-form-backdrop" data-search-close aria-hidden="true"></div>

                        <section id="navbar-search-panel"
                                 class="search-form-panel"
                                 aria-label="Filtros de búsqueda">
                            <div class="search-form-panel-header">
                                <div class="search-form-panel-heading">
                                    <p class="search-form-panel-kicker">Busqueda avanzada</p>
                                    <h2 class="search-form-panel-title">Curá la cartelera con precisión</h2>
                                </div>

                                <button type="button"
                                        class="search-form-panel-close"
                                        data-search-close
                                        aria-label="Cerrar filtros">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                         stroke="currentColor" stroke-width="2"
                                         stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="6" y1="6" x2="18" y2="18" />
                                        <line x1="18" y1="6" x2="6" y2="18" />
                                    </svg>
                                </button>
                            </div>

                            <p class="search-form-panel-copy">
                                Combiná género, sala, rango de fechas y disponibilidad en una capa flotante sin romper la composición del header.
                            </p>

                            <c:if test="${not empty searchFeedback}">
                                <p class="search-form-error search-form-error-panel"><c:out value="${searchFeedback}" /></p>
                            </c:if>

                            <div class="search-form-active-filters">
                                <div class="search-form-active-filters-header">
                                    <p class="search-form-active-filters-kicker">Filtros activos</p>
                                    <span class="search-form-active-filters-count ${activeFilterCount == 0 ? 'is-empty' : ''}" data-search-filter-count>
                                        <c:out value="${activeFilterCount}" />
                                    </span>
                                </div>

                                <div class="search-form-chip-list" data-search-chip-list>
                                    <c:if test="${not empty param.genre}">
                                        <span class="search-form-chip">Género: <c:out value="${param.genre}" /></span>
                                    </c:if>
                                    <c:if test="${not empty param.theater}">
                                        <span class="search-form-chip">Sala: <c:out value="${param.theater}" /></span>
                                    </c:if>
                                    <c:if test="${not empty param.dateFrom}">
                                        <span class="search-form-chip">Desde: <c:out value="${param.dateFrom}" /></span>
                                    </c:if>
                                    <c:if test="${not empty param.dateTo}">
                                        <span class="search-form-chip">Hasta: <c:out value="${param.dateTo}" /></span>
                                    </c:if>
                                    <c:if test="${param.available == 'true'}">
                                        <span class="search-form-chip">Solo disponibles</span>
                                    </c:if>
                                </div>

                                <p class="search-form-empty-state" data-search-empty-state ${hasActiveFilters ? 'hidden="hidden"' : ''}>
                                    Todavía no hay filtros activos. Afiná la búsqueda para descubrir una cartelera más precisa.
                                </p>
                            </div>

                            <div class="search-form-grid search-form-grid-navbar">
                                <div class="search-form-field">
                                    <label class="search-form-label" for="navbar-search-genre">Género</label>
                                    <select id="navbar-search-genre" name="genre" class="search-form-select">
                                        <option value="">Todos los géneros</option>
                                        <c:forEach var="searchGenre" items="${searchGenres}">
                                            <option value="${fn:escapeXml(searchGenre)}" ${param.genre == searchGenre ? 'selected' : ''}>
                                                <c:out value="${searchGenre}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="search-form-field">
                                    <label class="search-form-label" for="navbar-search-theater">Sala</label>
                                    <select id="navbar-search-theater" name="theater" class="search-form-select">
                                        <option value="">Todas las salas</option>
                                        <c:forEach var="searchTheater" items="${searchTheaters}">
                                            <option value="${fn:escapeXml(searchTheater)}" ${param.theater == searchTheater ? 'selected' : ''}>
                                                <c:out value="${searchTheater}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="search-form-field">
                                    <label class="search-form-label" for="navbar-search-date-from">Fecha desde</label>
                                    <input id="navbar-search-date-from"
                                           type="date"
                                           name="dateFrom"
                                           value="${fn:escapeXml(param.dateFrom)}"
                                           class="search-form-input search-form-input-date" />
                                </div>

                                <div class="search-form-field">
                                    <label class="search-form-label" for="navbar-search-date-to">Fecha hasta</label>
                                    <input id="navbar-search-date-to"
                                           type="date"
                                           name="dateTo"
                                           value="${fn:escapeXml(param.dateTo)}"
                                           class="search-form-input search-form-input-date" />
                                </div>

                                <label class="search-form-check search-form-check-navbar" for="navbar-search-available">
                                    <input id="navbar-search-available"
                                           class="search-form-check-input"
                                           type="checkbox"
                                           name="available"
                                           value="true"
                                           ${param.available == 'true' ? 'checked' : ''} />
                                    <span class="search-form-check-indicator" aria-hidden="true"></span>
                                    <span class="search-form-check-copy">
                                        <span class="search-form-check-title">Solo disponibles</span>
                                        <span class="search-form-check-meta">Mostrá funciones con disponibilidad inmediata.</span>
                                    </span>
                                </label>
                            </div>

                            <div class="search-form-actions">
                                <button type="submit" class="btn btn-primary btn-sm search-form-submit search-form-submit-panel">
                                    Aplicar filtros
                                </button>
                                <button type="button"
                                        class="btn btn-outline btn-sm search-form-reset"
                                        ${activeFilterCount == 0 ? 'disabled="disabled" aria-disabled="true"' : ''}
                                        data-search-clear-filters>
                                    Limpiar
                                </button>
                            </div>
                        </section>
                    </div>

                    <label class="search-form-query search-form-query-navbar" for="navbar-search-q">
                        <span class="search-form-icon" aria-hidden="true">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2.05"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="7"/>
                                <line x1="16.5" y1="16.5" x2="21" y2="21"/>
                            </svg>
                        </span>
                        <input id="navbar-search-q"
                               type="text"
                               name="q"
                               value="${fn:escapeXml(param.q)}"
                               placeholder="Buscar obra, sala o productora"
                               maxlength="100"
                               class="search-form-input search-form-input-query" />
                    </label>

                    <button type="submit" class="btn btn-primary btn-sm search-form-submit search-form-submit-navbar">
                        Buscar
                    </button>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="search-form-page-shell">
                <c:if test="${not empty error}">
                    <p class="search-form-error"><c:out value="${error}" /></p>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
</form>
