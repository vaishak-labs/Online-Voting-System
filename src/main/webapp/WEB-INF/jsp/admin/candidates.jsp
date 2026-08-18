<c:set var="pageTitle" value="Manage Candidates - Admin Console" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold text-dark mb-1"><i class="fa-solid fa-users text-primary me-2"></i> Candidates Registry</h3>
            <p class="text-muted small mb-0">View, add, edit, or remove candidate profiles per election</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/candidates/new?electionId=${selectedElectionId}" class="btn btn-primary-custom">
            <i class="fa-solid fa-user-plus me-1"></i> Add New Candidate
        </a>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
            <i class="fa-solid fa-circle-check me-1"></i> ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Filter by Election Dropdown & Search -->
    <div class="card card-custom p-3 mb-4">
        <div class="row g-3 align-items-center">
            <div class="col-md-7">
                <form action="${pageContext.request.contextPath}/admin/candidates" method="get" class="d-flex align-items-center gap-2">
                    <label for="electionId" class="fw-bold text-secondary small text-nowrap">Filter Election:</label>
                    <select name="electionId" id="electionId" class="form-select" onchange="this.form.submit()">
                        <c:forEach items="${elections}" var="election">
                            <option value="${election.id}" ${election.id == selectedElectionId ? 'selected' : ''}>
                                ${election.title} (${election.category})
                            </option>
                        </c:forEach>
                    </select>
                </form>
            </div>
            <div class="col-md-5">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" id="candidateSearch" class="form-control border-start-0 ps-0" placeholder="Search candidate by name or party..." onkeyup="filterCandidates()">
                </div>
            </div>
        </div>
    </div>

    <!-- Candidate Cards Grid -->
    <div class="row g-4" id="candidatesGrid">
        <c:choose>
            <c:when test="${not empty candidates}">
                <c:forEach items="${candidates}" var="candidate">
                    <div class="col-md-6 col-lg-4 candidate-item" data-name="${fn:toLowerCase(candidate.name)}" data-party="${fn:toLowerCase(candidate.party)}">
                        <div class="card card-custom h-100 p-4 text-center d-flex flex-column justify-content-between">
                            <div>
                                <img src="${not empty candidate.symbolUrl ? candidate.symbolUrl : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80'}" alt="${candidate.name}" class="candidate-avatar mx-auto mb-3">
                                <h5 class="fw-bold text-dark mb-1">${candidate.name}</h5>
                                <div class="mb-3">
                                    <span class="party-badge">${candidate.party}</span>
                                </div>
                                <p class="text-muted small mb-3 text-start bg-light p-3 rounded-3 border">${candidate.bio}</p>
                            </div>
                            <div>
                                <div class="mb-3 pt-2 border-top">
                                    <span class="fw-bold text-primary fs-5">${candidate.voteCount}</span> <span class="text-muted small">Total Votes Tally</span>
                                </div>
                                <div class="d-flex justify-content-center gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/candidates/${candidate.id}/edit" class="btn btn-sm btn-outline-info rounded-pill px-3">
                                        <i class="fa-solid fa-user-pen me-1"></i> Edit Profile
                                    </a>
                                    <form action="${pageContext.request.contextPath}/admin/candidates/${candidate.id}/delete" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to remove candidate ${candidate.name}?');">
                                        <sec:csrfInput/>
                                        <input type="hidden" name="electionId" value="${selectedElectionId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                            <i class="fa-solid fa-trash me-1"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center py-5">
                    <i class="fa-solid fa-user-slash fa-3x text-muted mb-3"></i>
                    <h5 class="fw-bold text-secondary">No Candidates Registered Yet</h5>
                    <p class="text-muted small mb-3">Click the button below to register the first candidate for this election.</p>
                    <a href="${pageContext.request.contextPath}/admin/candidates/new?electionId=${selectedElectionId}" class="btn btn-primary-custom">
                        <i class="fa-solid fa-plus me-1"></i> Add Candidate Now
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function filterCandidates() {
        var input = document.getElementById("candidateSearch").value.toLowerCase();
        var items = document.querySelectorAll(".candidate-item");

        items.forEach(function(item) {
            var name = item.getAttribute("data-name");
            var party = item.getAttribute("data-party");
            if (name.includes(input) || party.includes(input)) {
                item.style.display = "";
            } else {
                item.style.display = "none";
            }
        });
    }
</script>

<%@ include file="../common/footer.jsp" %>
