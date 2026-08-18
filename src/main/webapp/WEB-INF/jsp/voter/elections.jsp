<c:set var="pageTitle" value="Elections Directory - Online Voting System" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold text-dark mb-1"><i class="fa-solid fa-box-archive text-primary me-2"></i> Elections Directory</h3>
            <p class="text-muted small mb-0">Browse all past, present, and upcoming official elections</p>
        </div>
        <div class="col-md-4">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                <input type="text" id="electionSearch" class="form-control border-start-0 ps-0" placeholder="Search elections by title or category..." onkeyup="filterElections()">
            </div>
        </div>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3 small mb-4" role="alert">
            <i class="fa-solid fa-circle-xmark me-1"></i> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4" id="electionsGrid">
        <c:forEach items="${allElections}" var="election">
            <div class="col-md-6 col-lg-4 election-card-item" data-title="${fn:toLowerCase(election.title)}" data-category="${fn:toLowerCase(election.category)}">
                <div class="card card-custom h-100 p-4 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fw-semibold">${election.category}</span>
                            <c:choose>
                                <c:when test="${election.status == 'ACTIVE'}">
                                    <span class="badge-status-active"><i class="fa-solid fa-circle text-success me-1"></i> ACTIVE</span>
                                </c:when>
                                <c:when test="${election.status == 'COMPLETED'}">
                                    <span class="badge-status-completed"><i class="fa-solid fa-lock me-1"></i> COMPLETED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status-upcoming"><i class="fa-solid fa-clock me-1"></i> UPCOMING</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h5 class="fw-bold text-dark mb-2">${election.title}</h5>
                        <p class="text-muted small mb-3">${election.description}</p>
                        <div class="text-muted small mb-4">
                            <div><i class="fa-regular fa-calendar me-1 text-primary"></i> <strong>Start:</strong> ${election.formattedStartDate}</div>
                            <div><i class="fa-regular fa-calendar-check me-1 text-danger"></i> <strong>End:</strong> ${election.formattedEndDate}</div>
                        </div>
                    </div>
                    <div class="d-flex flex-column gap-2">
                        <c:choose>
                            <c:when test="${votedElectionIds.contains(election.id)}">
                                <button class="btn btn-success w-100 py-2 rounded-pill fw-bold mb-1" disabled>
                                    <i class="fa-solid fa-circle-check me-1"></i> Ballot Cast
                                </button>
                            </c:when>
                            <c:when test="${election.status == 'ACTIVE'}">
                                <a href="${pageContext.request.contextPath}/voter/vote/${election.id}" class="btn btn-primary-custom w-100 py-2">
                                    <i class="fa-solid fa-check-to-slot me-1"></i> Cast Vote
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-secondary w-100 py-2 rounded-pill" disabled>
                                    Voting Closed
                                </button>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/voter/results/${election.id}" class="btn btn-outline-secondary btn-sm w-100 py-1 rounded-pill">
                            <i class="fa-solid fa-chart-column me-1"></i> View Live Tally & Results
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function filterElections() {
        var input = document.getElementById("electionSearch").value.toLowerCase();
        var cards = document.querySelectorAll(".election-card-item");

        cards.forEach(function(card) {
            var title = card.getAttribute("data-title");
            var category = card.getAttribute("data-category");
            if (title.includes(input) || category.includes(input)) {
                card.style.display = "";
            } else {
                card.style.display = "none";
            }
        });
    }
</script>

<%@ include file="../common/footer.jsp" %>
