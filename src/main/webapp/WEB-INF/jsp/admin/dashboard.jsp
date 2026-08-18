<c:set var="pageTitle" value="Admin Dashboard - Online Voting System" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <!-- Admin Header Banner -->
    <div class="card card-custom p-4 mb-4" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: white;">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge bg-danger rounded-pill px-3 py-2 fw-bold mb-2">ELECTION COMMISSION CONTROL CENTER</span>
                <h2 class="fw-bold mb-1">Election Management Console</h2>
                <p class="mb-0 text-white-50">Oversee elections, manage registered candidate profiles, verify voters, and view real-time tallies.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/elections/new" class="btn btn-primary-custom px-3 py-2">
                    <i class="fa-solid fa-plus me-1"></i> Create Election
                </a>
                <a href="${pageContext.request.contextPath}/admin/candidates/new" class="btn btn-outline-light px-3 py-2 rounded-pill">
                    <i class="fa-solid fa-user-plus me-1"></i> Add Candidate
                </a>
            </div>
        </div>
    </div>

    <!-- Admin Metric Cards -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card card-custom stat-card">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Total Registered Voters</div>
                        <h2 class="fw-bold text-dark mb-0">${totalVoters}</h2>
                    </div>
                    <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-circle">
                        <i class="fa-solid fa-users fa-xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-custom stat-card success">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Active Elections</div>
                        <h2 class="fw-bold text-dark mb-0">${activeElectionsCount}</h2>
                    </div>
                    <div class="p-3 bg-success bg-opacity-10 text-success rounded-circle">
                        <i class="fa-solid fa-circle-play fa-xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-custom stat-card warning">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Total Elections Created</div>
                        <h2 class="fw-bold text-dark mb-0">${totalElections}</h2>
                    </div>
                    <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-circle">
                        <i class="fa-solid fa-box-archive fa-xl"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Elections Table -->
    <div class="card card-custom p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold text-dark mb-0"><i class="fa-solid fa-list-check text-primary me-2"></i> Recent Elections Overview</h4>
            <a href="${pageContext.request.contextPath}/admin/elections" class="btn btn-outline-primary btn-sm rounded-pill px-3">Manage All</a>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-secondary small text-uppercase">
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${recentElections}" var="election">
                        <tr>
                            <td><code>#${election.id}</code></td>
                            <td class="fw-bold text-dark">${election.title}</td>
                            <td><span class="badge bg-light text-dark border">${election.category}</span></td>
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
                                <a href="${pageContext.request.contextPath}/admin/results/${election.id}" class="btn btn-sm btn-primary-custom">
                                    <i class="fa-solid fa-chart-simple me-1"></i> Live Tally & Results
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
