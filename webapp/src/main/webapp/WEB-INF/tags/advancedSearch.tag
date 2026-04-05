<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="variant" required="true" %>
<%@ attribute name="error" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:url var="searchUrl" value="/search" />
<c:set var="hasActiveFilters" value="${not empty param.genre or not empty param.theater or not empty param.location or not empty param.date or param.available == 'true'}" />
<c:set var="activeFilterCount" value="${(not empty param.genre ? 1 : 0) + (not empty param.theater ? 1 : 0) + (not empty param.location ? 1 : 0) + (not empty param.date ? 1 : 0) + (param.available == 'true' ? 1 : 0)}" />
<c:set var="searchFeedback" value="${error}" />

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
                                <h2 class="search-form-panel-title">Busqueda avanzada</h2>

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

                            <c:if test="${not empty searchFeedback}">
                                <p class="search-form-error search-form-error-panel"><c:out value="${searchFeedback}" /></p>
                            </c:if>

                            <div class="search-form-grid search-form-grid-navbar">
                                <div class="search-form-field">
                                    <label class="search-form-label" for="navbar-search-genre">Género</label>
                                    <div class="search-form-combobox" data-filter-combobox>
                                        <label class="search-form-query search-form-query-panel" for="navbar-search-genre">
                                            <span class="search-form-icon" aria-hidden="true">
                                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                     stroke="currentColor" stroke-width="2.05"
                                                     stroke-linecap="round" stroke-linejoin="round">
                                                    <circle cx="11" cy="11" r="7"/>
                                                    <line x1="16.5" y1="16.5" x2="21" y2="21"/>
                                                </svg>
                                            </span>
                                            <input id="navbar-search-genre"
                                                   type="text"
                                                   name="genre"
                                                   value="${fn:escapeXml(param.genre)}"
                                                   placeholder="Buscar genero"
                                                   autocomplete="off"
                                                   class="search-form-input search-form-input-query"
                                                   data-filter-input
                                                   aria-expanded="false"
                                                   aria-controls="navbar-search-genre-list" />
                                        </label>

                                        <div id="navbar-search-genre-list"
                                             class="search-form-combobox-dropdown"
                                             data-filter-dropdown
                                             role="listbox">
                                            <ul class="search-form-combobox-options" data-filter-options>
                                                <c:forEach var="searchGenre" items="${searchGenres}">
                                                    <li class="search-form-combobox-item" data-filter-item>
                                                        <button type="button"
                                                                class="search-form-combobox-option"
                                                                data-filter-option
                                                                data-filter-value="${fn:escapeXml(searchGenre)}"
                                                                role="option">
                                                            <c:out value="${searchGenre}" />
                                                        </button>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                            <p class="search-form-combobox-empty" data-filter-empty hidden>
                                                No encontramos generos para esa busqueda.
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="search-form-field">
                                    <label class="search-form-label" for="navbar-search-theater">Sala</label>
                                    <div class="search-form-combobox" data-filter-combobox>
                                        <label class="search-form-query search-form-query-panel" for="navbar-search-theater">
                                            <span class="search-form-icon" aria-hidden="true">
                                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                     stroke="currentColor" stroke-width="2.05"
                                                     stroke-linecap="round" stroke-linejoin="round">
                                                    <circle cx="11" cy="11" r="7"/>
                                                    <line x1="16.5" y1="16.5" x2="21" y2="21"/>
                                                </svg>
                                            </span>
                                            <input id="navbar-search-theater"
                                                   type="text"
                                                   name="theater"
                                                   value="${fn:escapeXml(param.theater)}"
                                                   placeholder="Buscar sala"
                                                   autocomplete="off"
                                                   class="search-form-input search-form-input-query"
                                                   data-filter-input
                                                   aria-expanded="false"
                                                   aria-controls="navbar-search-theater-list" />
                                        </label>

                                        <div id="navbar-search-theater-list"
                                             class="search-form-combobox-dropdown"
                                             data-filter-dropdown
                                             role="listbox">
                                            <ul class="search-form-combobox-options" data-filter-options>
                                                <c:forEach var="searchTheater" items="${searchTheaters}">
                                                    <li class="search-form-combobox-item" data-filter-item>
                                                        <button type="button"
                                                                class="search-form-combobox-option"
                                                                data-filter-option
                                                                data-filter-value="${fn:escapeXml(searchTheater)}"
                                                                role="option">
                                                            <c:out value="${searchTheater}" />
                                                        </button>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                            <p class="search-form-combobox-empty" data-filter-empty hidden>
                                                No encontramos salas para esa busqueda.
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="search-form-field">
                                    <label class="search-form-label" for="navbar-search-date">Fecha</label>
                                    <input id="navbar-search-date"
                                           type="date"
                                           name="date"
                                           value="${fn:escapeXml(param.date)}"
                                           class="search-form-input search-form-input-date" />
                                </div>

                                <div class="search-form-field search-form-location-field">
                                    <label class="search-form-label" for="navbar-search-location">Zona</label>
                                    <div class="search-form-combobox" data-filter-combobox>
                                        <label class="search-form-query search-form-query-panel" for="navbar-search-location">
                                            <span class="search-form-icon" aria-hidden="true">
                                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                     stroke="currentColor" stroke-width="2.05"
                                                     stroke-linecap="round" stroke-linejoin="round">
                                                    <circle cx="11" cy="11" r="7"/>
                                                    <line x1="16.5" y1="16.5" x2="21" y2="21"/>
                                                </svg>
                                            </span>
                                            <input id="navbar-search-location"
                                                   type="text"
                                                   name="location"
                                                   value="${fn:escapeXml(param.location)}"
                                                   placeholder="Buscar zona"
                                                   autocomplete="off"
                                                   class="search-form-input search-form-input-query"
                                                   data-filter-input
                                                   aria-expanded="false"
                                                   aria-controls="navbar-search-location-list" />
                                        </label>

                                        <div id="navbar-search-location-list"
                                             class="search-form-combobox-dropdown"
                                             data-filter-dropdown
                                             role="listbox">
                                            <ul class="search-form-combobox-options" data-filter-options>
                                                <c:forEach var="searchLocation" items="${searchLocations}">
                                                    <li class="search-form-combobox-item" data-filter-item>
                                                        <button type="button"
                                                                class="search-form-combobox-option"
                                                                data-filter-option
                                                                data-filter-value="${fn:escapeXml(searchLocation)}"
                                                                role="option">
                                                            <c:out value="${searchLocation}" />
                                                        </button>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                            <p class="search-form-combobox-empty" data-filter-empty hidden>
                                                No encontramos zonas para esa busqueda.
                                            </p>
                                        </div>
                                    </div>
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
