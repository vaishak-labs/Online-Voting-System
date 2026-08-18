<c:set var="pageTitle" value="Election Results - ${election.title}" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <!-- Election Header -->
    <div class="card card-custom p-4 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fw-bold">${election.category}</span>
            <c:choose>
                <c:when test="${election.status == 'ACTIVE'}">
                    <span class="badge-status-active"><i class="fa-solid fa-signal text-success me-1"></i> LIVE VOTE TALLYING IN PROGRESS</span>
                </c:when>
                <c:otherwise>
                    <span class="badge-status-completed"><i class="fa-solid fa-lock me-1"></i> ELECTION OFFICIAL RESULTS FINALIZED</span>
                </c:otherwise>
            </c:choose>
        </div>
        <h2 class="fw-bold text-dark mb-2">${election.title}</h2>
        <p class="text-muted mb-0">${election.description}</p>
    </div>

    <!-- Winner Announcement Banner (If any votes cast) -->
    <c:if test="${not empty winner && totalVotes > 0}">
        <div class="card card-custom p-4 mb-4" style="background: linear-gradient(135deg, #065f46 0%, #047857 100%); color: white;">
            <div class="d-flex align-items-center gap-4">
                <img src="${not empty winner.symbolUrl ? winner.symbolUrl : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80'}" alt="${winner.name}" class="candidate-avatar" style="width: 100px; height: 100px; border-color: #fbbf24;">
                <div>
                    <span class="badge bg-warning text-dark px-3 py-1 rounded-pill fw-bold mb-2"><i class="fa-solid fa-crown me-1"></i> LEADING / WINNER</span>
                    <h3 class="fw-bold mb-1">${winner.name}</h3>
                    <div class="mb-2"><span class="badge bg-white bg-opacity-20 text-white">${winner.party}</span></div>
                    <div class="fs-5 text-white-50">Total Votes: <strong class="text-warning">${winner.voteCount}</strong> out of ${totalVotes} cast ballots</div>
                </div>
            </div>
        </div>
    </c:if>

    <div class="row g-4 mb-4">
        <!-- Interactive Chart Card -->
        <div class="col-lg-5">
            <div class="card card-custom h-100 p-4 d-flex flex-column align-items-center justify-content-center text-center">
                <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-chart-pie text-info me-2"></i> Vote Share Breakdown</h5>
                <c:choose>
                    <c:when test="${totalVotes > 0}">
                        <div style="width: 100%; max-width: 280px; position: relative;">
                            <canvas id="resultsChart"></canvas>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-muted py-5">
                            <i class="fa-solid fa-chart-simple fa-3x mb-3 text-secondary"></i>
                            <h6>No votes recorded yet</h6>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Vote Breakdown List -->
        <div class="col-lg-7">
            <div class="card card-custom h-100 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold text-dark mb-0"><i class="fa-solid fa-chart-column text-primary me-2"></i> Candidate Tallies</h4>
                    <span class="badge bg-light text-dark fs-6 px-3 py-2 border">Total Ballots Cast: <strong>${totalVotes}</strong></span>
                </div>

                <div class="d-flex flex-column gap-3">
                    <c:forEach items="${candidates}" var="candidate">
                        <c:set var="percentage" value="${totalVotes > 0 ? (candidate.voteCount * 100.0 / totalVotes) : 0}" />
                        <div class="p-3 bg-light rounded-3 border">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-3">
                                    <img src="${not empty candidate.symbolUrl ? candidate.symbolUrl : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80'}" alt="${candidate.name}" style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%;">
                                    <div>
                                        <h6 class="fw-bold text-dark mb-0">${candidate.name}</h6>
                                        <span class="badge bg-secondary bg-opacity-20 text-dark small">${candidate.party}</span>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <h6 class="fw-bold text-primary mb-0">${candidate.voteCount} Votes</h6>
                                    <span class="text-muted small"><fmt:formatNumber type="number" maxFractionDigits="1" value="${percentage}"/>%</span>
                                </div>
                            </div>
                            <!-- Animated Vote Bar -->
                            <div class="vote-progress">
                                <div class="vote-progress-bar h-100" style="width: ${percentage}%;"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-primary rounded-pill px-4" onclick="window.print()">
            <i class="fa-solid fa-print me-1"></i> Print Official Tally
        </button>
        <a href="${pageContext.request.contextPath}/admin/elections" class="btn btn-secondary rounded-pill px-4">
            <i class="fa-solid fa-arrow-left me-1"></i> Back to Elections
        </a>
    </div>
</div>

<c:if test="${totalVotes > 0}">
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const labels = [];
        const data = [];
        const colors = ['#4f46e5', '#06b6d4', '#10b981', '#f59e0b', '#ec4899', '#8b5cf6'];

        <c:forEach items="${candidates}" var="c" varStatus="status">
            labels.push("${c.name}");
            data.push(${c.voteCount});
        </c:forEach>

        const ctx = document.getElementById('resultsChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: colors.slice(0, labels.length),
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    });
</script>
</c:if>

<%@ include file="../common/footer.jsp" %>
