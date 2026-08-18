<c:set var="pageTitle" value="Voters Registry - Admin Console" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold text-dark mb-1"><i class="fa-solid fa-id-card text-primary me-2"></i> Registered Voters Registry</h3>
            <p class="text-muted small mb-0">Manage voter credentials, verification status, and voter accounts</p>
        </div>
        <div class="col-md-4">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                <input type="text" id="voterSearch" class="form-control border-start-0 ps-0" placeholder="Filter by Name, Email, or Voter ID..." onkeyup="filterVoters()">
            </div>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
            <i class="fa-solid fa-circle-check me-1"></i> ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3 small mb-4" role="alert">
            <i class="fa-solid fa-circle-exclamation me-1"></i> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card card-custom p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="votersTable">
                <thead class="table-light text-secondary small text-uppercase">
                    <tr>
                        <th>Voter ID</th>
                        <th>Full Name</th>
                        <th>Email Address</th>
                        <th>Registration Date</th>
                        <th>Verification Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${voters}" var="voter">
                        <tr>
                            <td><code class="bg-light text-primary px-2 py-1 rounded fw-bold">${voter.voterId}</code></td>
                            <td class="fw-bold text-dark">${voter.fullName}</td>
                            <td class="text-muted">${voter.email}</td>
                            <td class="text-muted small">${voter.formattedCreatedAt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${voter.verified}">
                                        <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-1">
                                            <i class="fa-solid fa-check-circle me-1"></i> VERIFIED
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3 py-1">
                                            <i class="fa-solid fa-clock me-1"></i> PENDING
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <form action="${pageContext.request.contextPath}/admin/voters/${voter.id}/toggle-verification" method="post" class="d-inline">
                                        <sec:csrfInput/>
                                        <c:choose>
                                            <c:when test="${voter.verified}">
                                                <button type="submit" class="btn btn-sm btn-outline-warning rounded-pill">
                                                    <i class="fa-solid fa-user-lock me-1"></i> Suspend
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" class="btn btn-sm btn-success rounded-pill">
                                                    <i class="fa-solid fa-user-check me-1"></i> Verify
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/admin/voters/${voter.id}/delete" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete voter account ${voter.fullName} (${voter.voterId})?');">
                                        <sec:csrfInput/>
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">
                                            <i class="fa-solid fa-user-xmark me-1"></i> Delete Account
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function filterVoters() {
        var input = document.getElementById("voterSearch").value.toLowerCase();
        var rows = document.querySelectorAll("#votersTable tbody tr");

        rows.forEach(function(row) {
            var text = row.innerText.toLowerCase();
            row.style.display = text.includes(input) ? "" : "none";
        });
    }
</script>

<%@ include file="../common/footer.jsp" %>
