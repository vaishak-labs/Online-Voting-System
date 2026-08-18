<c:set var="pageTitle" value="Create New Election - Admin Console" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card card-custom p-4">
                <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
                    <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-circle">
                        <i class="fa-solid fa-square-plus fa-2x"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold text-dark mb-0">Create New Election</h3>
                        <p class="text-muted small mb-0">Configure election details, timeline, and category</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/elections/new" method="post">
                    <sec:csrfInput/>
                    <div class="mb-3">
                        <label for="title" class="form-label fw-semibold small text-secondary">Election Title</label>
                        <input type="text" class="form-control" id="title" name="title" placeholder="e.g. 2026 Board of Directors Election" required>
                    </div>

                    <div class="mb-3">
                        <label for="category" class="form-label fw-semibold small text-secondary">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="National">National / General</option>
                            <option value="Municipal">State / Municipal</option>
                            <option value="Campus">University / Campus</option>
                            <option value="Corporate">Corporate / Board</option>
                            <option value="Organization">Non-Profit / Organization</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-semibold small text-secondary">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" placeholder="Explain the context, key policy issues, or guidelines for voters..." required></textarea>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="startDate" class="form-label fw-semibold small text-secondary">Start Date & Time</label>
                            <input type="datetime-local" class="form-control" id="startDate" name="startDate" required>
                        </div>
                        <div class="col-md-6">
                            <label for="endDate" class="form-label fw-semibold small text-secondary">End Date & Time</label>
                            <input type="datetime-local" class="form-control" id="endDate" name="endDate" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="status" class="form-label fw-semibold small text-secondary">Initial Status</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="ACTIVE" selected>ACTIVE (Open immediately)</option>
                            <option value="UPCOMING">UPCOMING (Scheduled for future)</option>
                        </select>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/elections" class="btn btn-light w-50 py-2 rounded-pill fw-semibold">Cancel</a>
                        <button type="submit" class="btn btn-primary-custom w-50 py-2">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Save & Launch Election
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Set default datetime values
    const now = new Date();
    const future = new Date(now.getTime() + (7 * 24 * 60 * 60 * 1000));
    
    document.getElementById('startDate').value = now.toISOString().slice(0, 16);
    document.getElementById('endDate').value = future.toISOString().slice(0, 16);
</script>

<%@ include file="../common/footer.jsp" %>
