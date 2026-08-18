<c:set var="pageTitle" value="Add Candidate - Admin Console" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card card-custom p-4">
                <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
                    <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-circle">
                        <i class="fa-solid fa-user-plus fa-2x"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold text-dark mb-0">Add Candidate Profile</h3>
                        <p class="text-muted small mb-0">Register a candidate for an active or upcoming election</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/candidates/new" method="post">
                    <sec:csrfInput/>
                    
                    <div class="mb-3">
                        <label for="electionId" class="form-label fw-semibold small text-secondary">Target Election</label>
                        <select class="form-select" id="electionId" name="electionId" required>
                            <c:forEach items="${elections}" var="election">
                                <option value="${election.id}" ${election.id == selectedElectionId ? 'selected' : ''}>
                                    ${election.title} (${election.category})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="name" class="form-label fw-semibold small text-secondary">Candidate Full Name</label>
                        <input type="text" class="form-control" id="name" name="name" placeholder="e.g. Dr. Eleanor Vance" required>
                    </div>

                    <div class="mb-3">
                        <label for="party" class="form-label fw-semibold small text-secondary">Political Party / Alliance Name</label>
                        <input type="text" class="form-control" id="party" name="party" placeholder="e.g. Forward Alliance" required>
                    </div>

                    <div class="mb-3">
                        <label for="symbolUrl" class="form-label fw-semibold small text-secondary">Photo / Party Emblem Image URL</label>
                        <input type="url" class="form-control" id="symbolUrl" name="symbolUrl" placeholder="https://images.unsplash.com/photo-..." required>
                        <div class="form-text extra-small">Provide a direct HTTPS image URL for candidate photo display.</div>
                    </div>

                    <div class="mb-4">
                        <label for="bio" class="form-label fw-semibold small text-secondary">Candidate Bio & Key Manifesto</label>
                        <textarea class="form-control" id="bio" name="bio" rows="3" placeholder="Brief statement of background, key qualifications, and policy goals..." required></textarea>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/candidates" class="btn btn-light w-50 py-2 rounded-pill fw-semibold">Cancel</a>
                        <button type="submit" class="btn btn-primary-custom w-50 py-2">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Register Candidate
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
