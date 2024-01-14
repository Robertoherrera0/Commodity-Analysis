document.addEventListener('DOMContentLoaded', function() {
    var form = document.querySelector('form');
    var loadingContainer = document.getElementById('loadingContainer');
    var iframes = document.querySelectorAll('iframe'); // Select all iframes

    // Initially hide all modals and previews
    var previews = ['arimaPreview', 'plotPreview', 'barchartPreview', 'strawPreview'];
    var modals = ['arimaModal', 'plotModal', 'barchartModal', 'strawModal'];
    previews.forEach(preview => document.getElementById(preview).classList.add('hidden'));
    modals.forEach(modal => document.getElementById(modal).classList.add('hidden'));

    form.addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent traditional form submission

        loadingContainer.classList.remove('hidden'); // Show loading container

        var formData = new FormData(form);
        fetch('/', {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(function(response) {
            if (!response.ok) {
                throw new Error('Server response was not ok.');
            }
            return response.json();
        }).then(function(data) {
            loadingContainer.classList.add('hidden'); // Hide loading container

            if (data.plot) {
                // Reload iframes to show new data
                iframes.forEach(function(iframe) {
                    iframe.contentWindow.location.reload(true);
                });
                // Show the widget previews
                previews.forEach(preview => document.getElementById(preview).classList.remove('hidden'));
            }
        }).catch(function(error) {
            console.error('Error:', error);
            loadingContainer.classList.add('hidden');
        });
    });

    // Event listeners for opening and closing modals
    previews.forEach(function(previewId, index) {
        document.getElementById(previewId).addEventListener('click', function() {
            document.getElementById(modals[index]).classList.remove('hidden');
        });
    });

    modals.forEach(modalId => {
        document.getElementById(modalId).addEventListener('click', function(event) {
            if (event.target === this) {
                this.classList.add('hidden');
            }
        });
    });
});
