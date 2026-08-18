<c:set var="pageTitle" value="Edit Election - Admin Console" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card card-custom p-4">
                <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
                    <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-circle">
                        <i class="fa-solid fa-pen-to-square fa-2x"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold text-dark mb-0">Edit Election #${election.id}</h3>
                        <p class="text-muted small mb-0">Update election parameters, category, schedule, or voting status</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/elections/${election.id}/edit" method="post">
                    <sec:csrfInput/>
                    
                    <div class="mb-3">
                        <label for="title" class="form-label fw-semibold small text-secondary">Election Title</label>
                        <input type="text" class="form-control" id="title" name="title" value="${election.title}" required>
                    </div>

                    <div class="mb-3">
                        <label for="category" class="form-label fw-semibold small text-secondary">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="National" ${election.category == 'National' ? 'selected' : ''}>National / General</option>
                            <option value="Municipal" ${election.category == 'Municipal' ? 'selected' : ''}>State / Municipal</option>
                            <option value="Campus" ${election.category == 'Campus' ? 'selected' : ''}>University / Campus</option>
                            <option value="Corporate" ${election.category == 'Corporate' ? 'selected' : ''}>Corporate / Board</option>
                            <option value="Organization" ${election.category == 'Organization' ? 'selected' : ''}>Non-Profit / Organization</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-semibold small text-secondary">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required>${election.description}</textarea>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="startDate" class="form-label fw-semibold small text-secondary">Start Date & Time</label>
                            <input type="datetime-local" class="form-control" id="startDate" name="startDate" value="${election.startDate}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="endDate" class="form-label fw-semibold small text-secondary">End Date & Time</label>
                            <input type="datetime-local" class="form-control" id="endDate" name="endDate" value="${election.endDate}" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="status" class="form-label fw-semibold small text-secondary">Voting Status</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="ACTIVE" ${election.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE (Open for voting)</option>
                            <option value="UPCOMING" ${election.status == 'UPCOMING' ? 'selected' : ''}>UPCOMING (Scheduled)</option>
                            <option value="COMPLETED" ${election.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED (Voting closed)</option>
                        </select>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/elections" class="btn btn-light w-50 py-2 rounded-pill fw-semibold">Cancel</a>
                        <button type="submit" class="btn btn-primary-custom w-50 py-2">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Update Election Details
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
