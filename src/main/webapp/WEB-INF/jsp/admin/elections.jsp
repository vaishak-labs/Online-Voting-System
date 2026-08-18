<c:set var="pageTitle" value="Manage Elections - Admin Console" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold text-dark mb-1"><i class="fa-solid fa-sliders text-primary me-2"></i> Manage Elections</h3>
            <p class="text-muted small mb-0">Create, edit, toggle status, or remove elections</p>
        </div>
        <div class="d-flex gap-2">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                <input type="text" id="adminElectionSearch" class="form-control border-start-0 ps-0" placeholder="Filter elections..." onkeyup="filterAdminElections()">
            </div>
            <a href="${pageContext.request.contextPath}/admin/elections/new" class="btn btn-primary-custom text-nowrap">
                <i class="fa-solid fa-plus me-1"></i> New Election
            </a>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
            <i class="fa-solid fa-circle-check me-1"></i> ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card card-custom p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="adminElectionsTable">
                <thead class="table-light text-secondary small text-uppercase">
                    <tr>
                        <th>ID</th>
                        <th>Election Title</th>
                        <th>Category</th>
                        <th>Start / End Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${elections}" var="election">
                        <tr>
                            <td><code>#${election.id}</code></td>
                            <td>
                                <div class="fw-bold text-dark">${election.title}</div>
                                <div class="text-muted extra-small">${election.description}</div>
                            </td>
                            <td><span class="badge bg-light text-primary border">${election.category}</span></td>
                            <td class="small text-muted">
                                <div>Start: ${election.formattedStartDate}</div>
                                <div>End: ${election.formattedEndDate}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${election.status == 'ACTIVE'}">
                                        <span class="badge-status-active">ACTIVE</span>
                                    </c:when>
                                    <c:when test="${election.status == 'COMPLETED'}">
                                        <span class="badge-status-completed">COMPLETED</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status-upcoming">UPCOMING</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex flex-wrap gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/results/${election.id}" class="btn btn-sm btn-outline-primary rounded-pill">
                                        <i class="fa-solid fa-chart-simple"></i> Results
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/candidates?electionId=${election.id}" class="btn btn-sm btn-outline-secondary rounded-pill">
                                        <i class="fa-solid fa-users"></i> Candidates (${election.candidates.size()})
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/elections/${election.id}/edit" class="btn btn-sm btn-outline-info rounded-pill">
                                        <i class="fa-solid fa-pen"></i> Edit
                                    </a>

                                    <form action="${pageContext.request.contextPath}/admin/elections/${election.id}/status" method="post" class="d-inline">
                                        <sec:csrfInput/>
                                        <c:choose>
                                            <c:when test="${election.status == 'ACTIVE'}">
                                                <input type="hidden" name="status" value="COMPLETED">
                                                <button type="submit" class="btn btn-sm btn-warning rounded-pill">
                                                    <i class="fa-solid fa-lock me-1"></i> Close
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" name="status" value="ACTIVE">
                                                <button type="submit" class="btn btn-sm btn-success rounded-pill">
                                                    <i class="fa-solid fa-play me-1"></i> Activate
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/admin/elections/${election.id}/delete" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this election? All associated candidates and cast votes will be permanently deleted.');">
                                        <sec:csrfInput/>
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">
                                            <i class="fa-solid fa-trash"></i>
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
    function filterAdminElections() {
        var input = document.getElementById("adminElectionSearch").value.toLowerCase();
        var rows = document.querySelectorAll("#adminElectionsTable tbody tr");

        rows.forEach(function(row) {
            var text = row.innerText.toLowerCase();
            row.style.display = text.includes(input) ? "" : "none";
        });
    }
</script>

<%@ include file="../common/footer.jsp" %>
