<c:set var="pageTitle" value="Voting Booth - ${election.title}" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <!-- Election Header Banner -->
    <div class="card card-custom p-4 mb-4 bg-white">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fw-bold">${election.category}</span>
            <span class="badge-status-active"><i class="fa-solid fa-shield-halved text-success me-1"></i> SECURE BALLOT SESSION</span>
        </div>
        <h3 class="fw-bold text-dark mb-2">${election.title}</h3>
        <p class="text-muted mb-0">${election.description}</p>
    </div>

    <!-- Instructions Banner -->
    <div class="alert alert-info border-0 rounded-3 mb-4 d-flex align-items-center gap-3">
        <i class="fa-solid fa-circle-info fa-2x text-info"></i>
        <div>
            <div class="fw-bold text-dark mb-1">Voting Instructions</div>
            <div class="small text-secondary">Review each registered candidate below. Click <strong>"Select & Cast Vote"</strong> on your chosen candidate. You will be prompted to confirm your choice before the vote is permanently encrypted and cast into the ballot box.</div>
        </div>
    </div>

    <!-- Candidate Selection Grid -->
    <div class="row g-4 mb-5">
        <c:forEach items="${candidates}" var="candidate">
            <div class="col-md-6 col-lg-4">
                <div class="candidate-card h-100 p-4 text-center d-flex flex-column justify-content-between shadow-sm" id="card-${candidate.id}">
                    <div>
                        <div class="position-relative d-inline-block mb-3">
                            <img src="${not empty candidate.symbolUrl ? candidate.symbolUrl : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80'}" alt="${candidate.name}" class="candidate-avatar">
                        </div>
                        <h4 class="fw-bold text-dark mb-1">${candidate.name}</h4>
                        <div class="mb-3">
                            <span class="party-badge"><i class="fa-solid fa-flag me-1"></i> ${candidate.party}</span>
                        </div>
                        <p class="text-muted small mb-4 text-start bg-light p-3 rounded-3 border">${candidate.bio}</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-outline-primary w-100 py-2 rounded-pill fw-bold" onclick="selectCandidate(${candidate.id}, '${candidate.name}', '${candidate.party}')">
                            <i class="fa-solid fa-check me-1"></i> Select & Cast Vote
                        </button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Vote Confirmation Modal -->
<div class="modal fade" id="confirmVoteModal" tabindex="-1" aria-labelledby="confirmVoteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow-lg">
            <div class="modal-header border-0 bg-primary text-white p-4 rounded-top-4">
                <h5 class="modal-title fw-bold" id="confirmVoteModalLabel">
                    <i class="fa-solid fa-shield-halved me-2"></i> Confirm Ballot Submission
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <div class="mb-3 text-warning">
                    <i class="fa-solid fa-triangle-exclamation fa-3x"></i>
                </div>
                <h4 class="fw-bold text-dark mb-2">Final Choice Confirmation</h4>
                <p class="text-muted small mb-4">You are about to cast your official vote for:</p>

                <div class="bg-light p-3 rounded-3 border mb-4 text-center">
                    <h5 class="fw-bold text-primary mb-1" id="modalCandidateName">Candidate Name</h5>
                    <span class="badge bg-secondary rounded-pill" id="modalCandidateParty">Party Name</span>
                </div>

                <p class="text-muted extra-small text-start bg-warning bg-opacity-10 p-3 rounded-3 text-warning-emphasis">
                    <i class="fa-solid fa-lock me-1"></i> <strong>Important:</strong> Once submitted, your vote is cryptographically logged under election ID #${election.id}. You cannot change or recast your vote.
                </p>

                <form id="voteSubmitForm" action="${pageContext.request.contextPath}/voter/vote" method="post">
                    <sec:csrfInput/>
                    <input type="hidden" name="electionId" value="${election.id}">
                    <input type="hidden" name="candidateId" id="modalCandidateId" value="">

                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-light w-50 py-2 rounded-pill fw-semibold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom w-50 py-2">
                            <i class="fa-solid fa-paper-plane me-1"></i> Confirm & Vote
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function selectCandidate(id, name, party) {
        document.querySelectorAll('.candidate-card').forEach(c => c.classList.remove('selected'));
        var card = document.getElementById('card-' + id);
        if (card) card.classList.add('selected');

        document.getElementById('modalCandidateId').value = id;
        document.getElementById('modalCandidateName').innerText = name;
        document.getElementById('modalCandidateParty').innerText = party;

        var modal = new bootstrap.Modal(document.getElementById('confirmVoteModal'));
        modal.show();
    }
</script>

<%@ include file="../common/footer.jsp" %>
