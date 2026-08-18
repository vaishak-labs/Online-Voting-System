<c:set var="pageTitle" value="Voter Dashboard - Secure Online Voting System" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <!-- Welcome Header -->
    <div class="card card-custom p-4 mb-4" style="background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%); color: white;">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge bg-info text-dark rounded-pill px-3 py-2 fw-bold mb-2">VOTER PORTAL</span>
                <h2 class="fw-bold mb-1">Welcome back, ${currentUser.fullName}!</h2>
                <p class="mb-0 text-white-50">Voter ID: <code class="bg-white bg-opacity-20 text-white px-2 py-1 rounded fs-6">${currentUser.voterId}</code> | Registered Email: ${currentUser.email}</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/voter/elections" class="btn btn-light text-primary fw-bold px-4 py-2 rounded-pill shadow-sm">
                    <i class="fa-solid fa-vote-yea me-2"></i> Cast Vote Now
                </a>
            </div>
        </div>
    </div>

    <!-- Quick Stats Row -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card card-custom stat-card">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Active Elections</div>
                        <h3 class="fw-bold text-dark mb-0">${activeElections.size()}</h3>
                    </div>
                    <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-circle">
                        <i class="fa-solid fa-box-archive fa-xl"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card card-custom stat-card success">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Ballots Cast</div>
                        <h3 class="fw-bold text-dark mb-0">${votedCount}</h3>
                    </div>
                    <div class="p-3 bg-success bg-opacity-10 text-success rounded-circle">
                        <i class="fa-solid fa-check-double fa-xl"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card card-custom stat-card warning">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Security Status</div>
                        <h5 class="fw-bold text-success mb-0"><i class="fa-solid fa-shield-check me-1"></i> Verified & Active</h5>
                    </div>
                    <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-circle">
                        <i class="fa-solid fa-user-shield fa-xl"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Ongoing Elections Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-0"><i class="fa-solid fa-fire text-danger me-2"></i> Active Elections</h4>
            <p class="text-muted small mb-0">Select an active election below to view candidates and cast your ballot</p>
        </div>
        <a href="${pageContext.request.contextPath}/voter/elections" class="text-primary fw-semibold text-decoration-none">View All <i class="fa-solid fa-arrow-right ms-1"></i></a>
    </div>

    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty activeElections}">
                <c:forEach items="${activeElections}" var="election">
                    <div class="col-md-6 col-lg-4">
                        <div class="card card-custom h-100 p-4 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fw-semibold">${election.category}</span>
                                    <span class="badge-status-active"><i class="fa-solid fa-circle text-success me-1 fs-6"></i> ACTIVE</span>
                                </div>
                                <h5 class="fw-bold text-dark mb-2">${election.title}</h5>
                                <p class="text-muted small mb-4">${election.description}</p>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${votedElectionIds.contains(election.id)}">
                                        <button class="btn btn-success w-100 py-2 rounded-pill fw-bold" disabled>
                                            <i class="fa-solid fa-circle-check me-1"></i> Ballot Already Cast
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/voter/vote/${election.id}" class="btn btn-primary-custom w-100 py-2">
                                            <i class="fa-solid fa-check-to-slot me-1"></i> Enter Voting Booth
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="card card-custom p-5 text-center">
                        <i class="fa-solid fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="fw-bold text-secondary">No Active Elections Right Now</h5>
                        <p class="text-muted small mb-0">Check back soon for upcoming national, local, or organization ballots.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
