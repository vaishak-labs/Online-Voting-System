<c:set var="pageTitle" value="My Voting Receipt History - Online Voting System" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-dark mb-1"><i class="fa-solid fa-receipt text-success me-2"></i> Official Voting Receipts</h3>
            <p class="text-muted small mb-0">Cryptographic proof of your submitted ballots with verifiable SHA-256 tokens</p>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 p-3 mb-4 shadow-sm" role="alert">
            <div class="d-flex align-items-center gap-2">
                <i class="fa-solid fa-circle-check fa-xl text-success"></i>
                <div>
                    <div class="fw-bold text-dark mb-0">Ballot Successfully Cast!</div>
                    <div class="small">${successMessage}</div>
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card card-custom p-4">
        <c:choose>
            <c:when test="${not empty votes}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-secondary small text-uppercase">
                            <tr>
                                <th>Verification Hash</th>
                                <th>Election Title</th>
                                <th>Candidate Voted For</th>
                                <th>Timestamp</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${votes}" var="vote">
                                <tr>
                                    <td>
                                        <code class="bg-light text-primary px-2 py-1 rounded small border fw-bold">${vote.receiptHash}</code>
                                    </td>
                                    <td class="fw-bold text-dark">${vote.election.title}</td>
                                    <td>
                                        <span class="fw-semibold text-primary">${vote.candidate.name}</span>
                                        <span class="badge bg-secondary bg-opacity-20 text-dark ms-1">${vote.candidate.party}</span>
                                    </td>
                                    <td class="text-muted small">${vote.formattedVotedAt}</td>
                                    <td>
                                        <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2">
                                            <i class="fa-solid fa-shield-check me-1"></i> VERIFIED & AUDITED
                                        </span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" 
                                                onclick="openReceiptModal('${vote.receiptHash}', '${vote.election.title}', '${vote.candidate.name}', '${vote.candidate.party}', '${currentUser.fullName}', '${currentUser.voterId}', '${vote.formattedVotedAt}')">
                                            <i class="fa-solid fa-print me-1"></i> Official Receipt
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="fa-solid fa-file-circle-xmark fa-3x text-muted mb-3"></i>
                    <h5 class="fw-bold text-secondary">No Ballot History Found</h5>
                    <p class="text-muted small mb-3">You have not cast any votes in current active elections yet.</p>
                    <a href="${pageContext.request.contextPath}/voter/elections" class="btn btn-primary-custom px-4 py-2">View Active Elections</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Receipt Modal -->
<div class="modal fade" id="receiptModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content rounded-4 border-0 shadow-lg" id="printableCertificate">
            <div class="modal-header border-0 bg-dark text-white p-4 rounded-top-4" style="background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%) !important;">
                <div class="d-flex align-items-center gap-2">
                    <i class="fa-solid fa-shield-halved fa-2x text-info"></i>
                    <div>
                        <h5 class="modal-title fw-bold text-white mb-0">Official Digital Ballot Receipt</h5>
                        <div class="small text-white-50">VoteVault Cryptography & Election Commission Integrity</div>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 p-md-5">
                <div class="border border-3 border-secondary border-opacity-25 p-4 rounded-3 text-center bg-light position-relative">
                    <div class="position-absolute top-0 end-0 p-3 opacity-25 d-none d-md-block">
                        <i class="fa-solid fa-stamp fa-4x text-success"></i>
                    </div>

                    <h4 class="fw-bold text-dark text-uppercase letter-spacing-1 mb-1">Cryptographic Ballot Certificate</h4>
                    <p class="text-muted small mb-4">State & Institutional Online Voting Registry</p>

                    <div class="row g-3 text-start mb-4">
                        <div class="col-md-6">
                            <div class="small text-muted text-uppercase fw-semibold">Voter Full Name</div>
                            <div class="fw-bold fs-6 text-dark" id="receiptVoterName">-</div>
                        </div>
                        <div class="col-md-6">
                            <div class="small text-muted text-uppercase fw-semibold">Official Voter ID</div>
                            <div class="fw-bold fs-6 text-primary" id="receiptVoterId">-</div>
                        </div>
                        <div class="col-md-6">
                            <div class="small text-muted text-uppercase fw-semibold">Election Title</div>
                            <div class="fw-bold fs-6 text-dark" id="receiptElectionTitle">-</div>
                        </div>
                        <div class="col-md-6">
                            <div class="small text-muted text-uppercase fw-semibold">Candidate Selected</div>
                            <div class="fw-bold fs-6 text-success" id="receiptCandidateName">-</div>
                        </div>
                        <div class="col-md-12">
                            <div class="small text-muted text-uppercase fw-semibold">Submission Timestamp</div>
                            <div class="text-dark small" id="receiptTimestamp">-</div>
                        </div>
                    </div>

                    <div class="bg-white p-3 rounded-3 border text-start mb-4">
                        <div class="small text-muted fw-semibold text-uppercase mb-1"><i class="fa-solid fa-key me-1 text-warning"></i> SHA-256 Verification Cipher:</div>
                        <code class="text-primary fw-bold fs-6 word-break-all" id="receiptHash">-</code>
                    </div>

                    <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fw-bold">
                            <i class="fa-solid fa-circle-check me-1"></i> STATUS: AUDITED & ENCRYPTED
                        </span>
                        <span class="small text-muted">VoteVault Security Protocol v2.4</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 p-4 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary-custom rounded-pill px-4" onclick="window.print()">
                    <i class="fa-solid fa-print me-1"></i> Print Official Receipt
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function openReceiptModal(hash, election, candidate, party, voterName, voterId, timestamp) {
        document.getElementById('receiptHash').innerText = hash;
        document.getElementById('receiptElectionTitle').innerText = election;
        document.getElementById('receiptCandidateName').innerText = candidate + " (" + party + ")";
        document.getElementById('receiptVoterName').innerText = voterName;
        document.getElementById('receiptVoterId').innerText = voterId;
        document.getElementById('receiptTimestamp').innerText = timestamp;

        var modal = new bootstrap.Modal(document.getElementById('receiptModal'));
        modal.show();
    }
</script>

<%@ include file="../common/footer.jsp" %>
